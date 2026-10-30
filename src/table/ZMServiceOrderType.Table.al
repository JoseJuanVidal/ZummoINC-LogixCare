table 50005 "ZM Service Order Type"
{
    DataClassification = CustomerContent;
    Caption = 'Aux List';
    LookupPageId = "ZM Service Order Type";
    DrillDownPageId = "ZM Service Order Type";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = "Service Order Type",Fault,"Localized Fault";
            OptionCaption = 'Service Order Type,Fault,Localized Fault';
        }
        field(2; Code; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(3; Code2; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code 2';
        }
        field(5; Description; text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(10; "Fault Spain"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Fault Spain';
        }
        field(11; "Fault Location Spain"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Fault Location Spain';
        }
    }

    keys
    {
        key(pk; Type, Code, Code2)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Description)
        { }
        fieldgroup(Brick; Code, Description)
        { }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;


}