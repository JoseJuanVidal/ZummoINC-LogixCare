table 50002 "LGX ZMO Service Warr. Comment"
{
    DataClassification = CustomerContent;
    Caption = 'Service & Warranty Comments';
    DataCaptionFields = "LGX ZMO Table Name", "LGX ZMO No.";

    fields
    {
        field(2; "LGX ZMO No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
            NotBlank = true;
        }
        field(4; "LGX ZMO Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(6; "LGX ZMO Comment"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Comment';
        }
        field(7; "LGX ZMO Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(9; "LGX ZMO Table Name"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Table Name';
            OptionCaption = 'Service & Warranty Header';
            OptionMembers = "Service & Warranty Header";
        }
    }

    keys
    {
        key(PK; "LGX ZMO Table Name", "LGX ZMO No.", "LGX ZMO Line No.")
        {
        }
    }
}

