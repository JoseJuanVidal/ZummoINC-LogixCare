# Extensión ZUMMO (LogixCare, LLC) — Zummo, Inc (BC14 NA)

Código extraído el 2026-10-30 del paquete publicado en la BD de Zummo, Inc (tabla `NAV App`, versión 1.0.0.44,
app id 54d024e0-581a-40ad-9d77-0501b08a0e33). El paquete original está en `LogixCare, LLC_ZUMMO_1.0.0.44_original.app`.
Estructura recompuesta: `src/<tipo>/*.al` y los layouts en `src/report/*.rdl(c)` (rutas de `RDLCLayout`).

- Depende de ella "Zummo Ext WARRANTY" (carpeta `ZummoInc Zummo`), que declara la dependencia 1.0.0.44.
- Símbolos: hay que descargarlos del servidor de Zummo Inc (localización US/NA). Los de BC140 local son de España
  y no compilan (faltan `Sales Tax Amount Line`, `Print On Invoice`, `Tax Identification Type`...).

## Motivo del proyecto: envío por email lento de facturas registradas
- Factura registrada = informe 50012 "LGX ZMO Sales Invoice"; abono = 50006.
- Con el layout personalizado 50012-000002 (Custom Report Layout, columnas ensanchadas el 16/10/2026 para los
  números largos tipo S-INVP26-000502) la vista previa tarda ~15 s y el email ~1 min. Con el layout integrado, 2-3 s.
- Cualquier layout personalizado del 50012 es lento (probado: el integrado importado como personalizado también).
- Solución: llevar los ajustes al layout integrado `src/report/LGXZMOSalesInvoice.Report.rdl` y publicar 1.0.0.45.
  Ajustes (6 elementos): InvoiceDateCaption1, InvoiceNumberCaption1, ZummoShipNoCaption Left 4.75709/4.75917in -> 4.53209/4.53417in;
  SalesInvoiceHeaderNo1, ExecutionTimeTextBox, ZummoShipmentNo Left 6.12183in -> 5.88294in y Width 0.92639/0.92431/0.94214in
  -> 1.16528/1.1632/1.18103in.
