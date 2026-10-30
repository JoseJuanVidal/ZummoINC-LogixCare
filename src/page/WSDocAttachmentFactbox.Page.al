page 50018 "W&S Doc. Attachment Factbox"
{

    PageType = CardPart;
    UsageCategory = None;
    SourceTable = "Unlinked Attachment";

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;
                field(Documents; Count)
                {
                    Editable = false;
                    StyleExpr = true;

                    trigger OnDrillDown()
                    var
                        UnlikedAttachment: Record "Unlinked Attachment";
                        WarrServiceDocAttach: page "ZM Warr. & Service Doc Attach";
                    begin
                        UnlikedAttachment.Reset();
                        UnlikedAttachment.SetRange("No.", RecNo);
                        UnlikedAttachment.SetRange(TypeDoc, DocType);
                        WarrServiceDocAttach.SetRecNo(RecNo, DocType);
                        WarrServiceDocAttach.SetTableView(UnlikedAttachment);
                        WarrServiceDocAttach.RunModal()
                    end;
                }
            }
        }
    }

    var
        RecNo: code[20];
        DocType: Option;

    procedure SetRecNo(vRecNo: code[20]; vTypeDoc: Option)
    var
        myInt: Integer;
    begin
        RecNo := vRecNo;
        DocType := vTypeDoc;
    end;
}