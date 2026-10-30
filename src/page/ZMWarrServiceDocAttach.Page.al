page 50017 "ZM Warr. & Service Doc Attach"
{
    Caption = 'Warranty & Service Doc Attachment';
    PageType = Worksheet;
    UsageCategory = None;
    SourceTable = "Unlinked Attachment";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("File Name"; "File Name")
                {
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        IF Content.HASVALUE THEN
                            Export(TRUE)
                        ELSE BEGIN
                            FileName := FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, STRSUBSTNO(FileDialogTxt, FilterTxt), FilterTxt);
                            IF FileName <> '' THEN
                                SaveAttachment(FileName, TempBlob);
                            CurrPage.UPDATE(FALSE);
                        END;
                    end;

                }
                field("Created Date-Time"; "Created Date-Time")
                {
                    Editable = false;
                }
                field(Type; Type)
                {
                    Editable = false;
                }
                field(Content; Content)
                {
                    Editable = False;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "File Name" := SelectFileTxt;
    end;

    var
        FileManagement: Codeunit "File Management";
        TempBlob: Record TempBlob;
        FileName: Text;
        RecNo: code[20];
        DocType: Option;
        FileDialogTxt: label 'Attachments (%1)|%1';
        SelectFileTxt: Label 'Select File...';
        FilterTxt: label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*';
        ImportTxt: Label 'Permite adjuntar un documento.';

    local procedure Export(ShowFileDialog: Boolean): Text
    var
        UnlinkedAttachment: record "Unlinked Attachment";
        DocumentStream: OutStream;
        FullFileName: text;
    begin
        // Ensure document has value in DB
        IF NOT Rec.Content.HASVALUE THEN
            EXIT;

        FullFileName := "File Name";
        if not UnlinkedAttachment.get(Rec.Id) then
            exit;
        UnlinkedAttachment.CalcFields(Content);
        TempBlob.Blob := UnlinkedAttachment.Content;
        EXIT(FileManagement.BLOBExport(TempBlob, FullFileName, ShowFileDialog));
    end;

    local procedure SaveAttachment(FileName: text; TempBlob: record TempBlob)
    var
        DocStream: InStream;
        IncomingFileName: text;
        EmptyFileNameErr: label 'Please choose a file to attach.';
        NoContentErr: Label 'The selected file has no content. Please choose another file.';
        NoDocumentAttachedErr: label 'Please attach a document first.';
    begin
        IF FileName = '' THEN
            ERROR(EmptyFileNameErr);
        // Validate file/media is not empty
        IF NOT TempBlob.Blob.HASVALUE THEN
            ERROR(NoContentErr);

        IncomingFileName := FileName;

        // VALIDATE("File Extension", FileManagement.GetExtension(IncomingFileName));
        Rec.VALIDATE("File Name", COPYSTR(FileManagement.GetFileName(IncomingFileName), 1, MAXSTRLEN("File Name")));

        Rec.Content := TempBlob.Blob;
        // IMPORTSTREAM(stream,description, mime-type,filename)
        // description and mime-type are set empty and will be automatically set by platform code from the stream
        // "Document Reference ID".IMPORTSTREAM(DocStream, '', '');
        // IF NOT "Document Reference ID".HASVALUE THEN
        //     ERROR(NoDocumentAttachedErr);
        // VALIDATE("Table ID", Database::"LGX ZMO Service & Warranty Hdr");
        Rec.Validate("Created Date-Time", CreateDateTime(WorkDate(), Time));
        Rec."No." := RecNo;
        Rec.TypeDoc := DocType;
        rec.Id := CreateGuid();
        Rec.Insert();
    end;

    procedure SetRecNo(NewNo: code[20]; NewTypeDoc: Option)
    begin
        RecNo := NewNo;
        DocType := newTypeDoc;
    end;
}
