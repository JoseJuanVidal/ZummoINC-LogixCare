/*
    Traspaso de datos de "Zummo Ext WARRANTY" (app e3ec16ab) a ZUMMO 1.0.0.46 (app 54d024e0).

    Requisitos previos:
      - WARRANTY desinstalada (sin -DoNotSaveData) y ZUMMO 1.0.0.46 instalada.
      - Backup de la BD.
      - Sin usuarios trabajando; al terminar, reiniciar el servicio de BC (cache).

    Que hace, para cada tabla '<Empresa>$<Tabla>$e3ec16ab-...' de todas las empresas:
      - Busca su pareja '<Empresa>$<Tabla>$54d024e0-...' (mismos nombres de columna, porque los campos
        tienen el mismo nombre en las dos apps).
      - UPDATE de las columnas de WARRANTY en las filas que ya existen en ZUMMO, cruzando por la clave
        primaria (tablas companeras de extensiones: Sales Header, Purchase Header, Unlinked Attachment...
        y la cabecera de Service & Warranty).
      - Ademas, si la tabla de ZUMMO tiene exactamente las mismas columnas (tablas nuevas
        "ZM Serv & Warr Items", "ZM Service Order Type", pero tambien alguna companera), INSERT de las
        filas que falten. En companeras con mas columnas no se insertan filas (BC ya las tiene creadas).
      - Comprueba al final que todas las filas de WARRANTY estan en ZUMMO con los mismos valores.

    @Ejecutar = 0 -> ensayo: hace todo dentro de una transaccion y al final ROLLBACK (no cambia nada).
    @Ejecutar = 1 -> igual, pero COMMIT si todas las comprobaciones salen bien.
    Las tablas de WARRANTY no se tocan en ningun caso.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @Ejecutar bit = 0;

DECLARE @Old nvarchar(40) = N'$e3ec16ab-a69a-4d56-acad-9f2fd5ce519f';
DECLARE @New nvarchar(40) = N'$54d024e0-581a-40ad-9d77-0501b08a0e33';

DECLARE @Bd sysname = DB_NAME();
PRINT N'Base de datos: ' + @Bd;
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name LIKE N'%' + @Old)
BEGIN
    RAISERROR(N'No hay tablas de WARRANTY en la base de datos %s. ¿Es la BD de BC correcta?', 16, 1, @Bd);
    RETURN;
END

DECLARE @Resultado TABLE (
    Tabla nvarchar(200), Modo nvarchar(10), FilasWarranty int, FilasAfectadas int,
    SinPareja int, Diferencias int, Error nvarchar(400));

BEGIN TRANSACTION;

DECLARE @Src sysname, @Dst sysname, @Modo nvarchar(10), @Pk nvarchar(max), @Cols nvarchar(max),
        @SetList nvarchar(max), @CmpCols nvarchar(max), @Sql nvarchar(max), @Err nvarchar(400),
        @Filas int, @Filas2 int, @Afectadas int, @SinPareja int, @Dif int;

DECLARE tablas CURSOR LOCAL FAST_FORWARD FOR
    SELECT name FROM sys.tables WHERE name LIKE N'%' + @Old ORDER BY name;
OPEN tablas;
FETCH NEXT FROM tablas INTO @Src;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Dst = LEFT(@Src, LEN(@Src) - LEN(@Old)) + @New;
    SELECT @Err = NULL, @Modo = NULL, @Filas = NULL, @Filas2 = 0, @Afectadas = 0, @SinPareja = NULL, @Dif = NULL;

    IF OBJECT_ID(QUOTENAME(@Dst)) IS NULL
        SET @Err = N'No existe la tabla destino';

    -- Columnas de WARRANTY que no existen en ZUMMO
    IF @Err IS NULL AND EXISTS (
        SELECT 1 FROM sys.columns s
        WHERE s.object_id = OBJECT_ID(QUOTENAME(@Src)) AND s.name <> 'timestamp'
          AND NOT EXISTS (SELECT 1 FROM sys.columns d WHERE d.object_id = OBJECT_ID(QUOTENAME(@Dst)) AND d.name = s.name))
        SET @Err = N'Columnas sin pareja: ' + (
            SELECT STRING_AGG(s.name, N', ') FROM sys.columns s
            WHERE s.object_id = OBJECT_ID(QUOTENAME(@Src)) AND s.name <> 'timestamp'
              AND NOT EXISTS (SELECT 1 FROM sys.columns d WHERE d.object_id = OBJECT_ID(QUOTENAME(@Dst)) AND d.name = s.name));

    IF @Err IS NULL
    BEGIN
        -- Clave primaria (la misma en las dos tablas)
        SELECT @Pk = STRING_AGG(CAST(N'd.' + QUOTENAME(c.name) + N' = s.' + QUOTENAME(c.name) AS nvarchar(max)), N' AND ')
        FROM sys.indexes i
        JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
        JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
        WHERE i.object_id = OBJECT_ID(QUOTENAME(@Src)) AND i.is_primary_key = 1;

        SELECT
            @Cols = STRING_AGG(CAST(QUOTENAME(s.name) AS nvarchar(max)), N', ') WITHIN GROUP (ORDER BY s.column_id),
            @SetList = STRING_AGG(CASE WHEN pk.column_id IS NULL
                           THEN CAST(N'd.' + QUOTENAME(s.name) + N' = s.' + QUOTENAME(s.name) AS nvarchar(max)) END, N', '),
            -- Para la comprobacion se excluyen BLOBs (no se pueden comparar con EXCEPT)
            @CmpCols = STRING_AGG(CASE WHEN TYPE_NAME(s.system_type_id) NOT IN ('image', 'text', 'ntext') AND s.max_length <> -1
                           THEN CAST(QUOTENAME(s.name) AS nvarchar(max)) END, N', ') WITHIN GROUP (ORDER BY s.column_id)
        FROM sys.columns s
        LEFT JOIN (SELECT ic.column_id FROM sys.indexes i
                   JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
                   WHERE i.object_id = OBJECT_ID(QUOTENAME(@Src)) AND i.is_primary_key = 1) pk ON pk.column_id = s.column_id
        WHERE s.object_id = OBJECT_ID(QUOTENAME(@Src)) AND s.name <> 'timestamp';

        -- Mismas columnas -> UPDATE + INSERT de las que falten; ZUMMO con mas columnas -> solo UPDATE
        SET @Modo = CASE WHEN EXISTS (
                SELECT 1 FROM sys.columns d
                WHERE d.object_id = OBJECT_ID(QUOTENAME(@Dst)) AND d.name <> 'timestamp'
                  AND NOT EXISTS (SELECT 1 FROM sys.columns s WHERE s.object_id = OBJECT_ID(QUOTENAME(@Src)) AND s.name = d.name))
            THEN N'UPDATE' ELSE N'UPD+INS' END;

        SET @Sql = N'SELECT @n = COUNT(*) FROM ' + QUOTENAME(@Src);
        EXEC sp_executesql @Sql, N'@n int OUTPUT', @n = @Filas OUTPUT;

        IF @SetList IS NOT NULL
        BEGIN
            SET @Sql = N'UPDATE d SET ' + @SetList + N' FROM ' + QUOTENAME(@Dst) + N' d JOIN ' + QUOTENAME(@Src) + N' s ON ' + @Pk
                     + N'; SET @n = @@ROWCOUNT;';
            EXEC sp_executesql @Sql, N'@n int OUTPUT', @n = @Afectadas OUTPUT;
        END

        IF @Modo = N'UPD+INS'
        BEGIN
            SET @Sql = N'INSERT INTO ' + QUOTENAME(@Dst) + N' (' + @Cols + N') SELECT ' + @Cols + N' FROM ' + QUOTENAME(@Src) + N' s'
                     + N' WHERE NOT EXISTS (SELECT 1 FROM ' + QUOTENAME(@Dst) + N' d WHERE ' + @Pk + N'); SET @n = @@ROWCOUNT;';
            EXEC sp_executesql @Sql, N'@n int OUTPUT', @n = @Filas2 OUTPUT;
            SET @Afectadas += @Filas2;
        END

        -- Filas de WARRANTY sin fila en ZUMMO (en UPDATE no se crean)
        SET @Sql = N'SELECT @n = COUNT(*) FROM ' + QUOTENAME(@Src) + N' s WHERE NOT EXISTS (SELECT 1 FROM ' + QUOTENAME(@Dst) + N' d WHERE ' + @Pk + N')';
        EXEC sp_executesql @Sql, N'@n int OUTPUT', @n = @SinPareja OUTPUT;

        -- Filas de WARRANTY cuyos valores no coinciden con ZUMMO tras el traspaso
        SET @Sql = N'SELECT @n = COUNT(*) FROM (SELECT ' + @CmpCols + N' FROM ' + QUOTENAME(@Src)
                 + N' EXCEPT SELECT ' + @CmpCols + N' FROM ' + QUOTENAME(@Dst) + N') x';
        EXEC sp_executesql @Sql, N'@n int OUTPUT', @n = @Dif OUTPUT;
    END

    INSERT @Resultado VALUES (LEFT(@Src, LEN(@Src) - LEN(@Old)), @Modo, @Filas, @Afectadas, @SinPareja, @Dif, @Err);
    FETCH NEXT FROM tablas INTO @Src;
END
CLOSE tablas;
DEALLOCATE tablas;

SELECT * FROM @Resultado ORDER BY Tabla;

IF EXISTS (SELECT 1 FROM @Resultado WHERE Error IS NOT NULL OR SinPareja > 0 OR Diferencias > 0)
BEGIN
    ROLLBACK TRANSACTION;
    PRINT N'HAY ERRORES O DIFERENCIAS: ROLLBACK, no se ha cambiado nada.';
END
ELSE IF @Ejecutar = 1
BEGIN
    COMMIT TRANSACTION;
    PRINT N'Traspaso confirmado (COMMIT). Reiniciar el servicio de BC.';
END
ELSE
BEGIN
    ROLLBACK TRANSACTION;
    PRINT N'Ensayo correcto (ROLLBACK, no se ha cambiado nada). Para aplicarlo: @Ejecutar = 1.';
END
