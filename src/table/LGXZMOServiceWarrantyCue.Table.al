table 50003 "LGX ZMO Service & Warranty Cue"
{
    DataClassification = CustomerContent;
    Caption = 'Service & Warranty Cue';

    fields
    {
        field(1; "LGX ZMO Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(2; "LGX ZMO Serv. Status - Opened"; Integer)
        {
            Caption = 'Service Status - Opened';
            CalcFormula = count ("LGX ZMO Service & Warranty Hdr" where("LGX ZMO Status" = const(Opened)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "LGX ZMO Serv. Status - Closed"; Integer)
        {
            Caption = 'Service Status - Closed';
            CalcFormula = count ("LGX ZMO Service & Warranty Hdr" where("LGX ZMO Status" = const(Closed)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "LGX ZMO Warr. Stat. - Repaired"; Integer)
        {
            Caption = 'Warranty Status - Repaired';
            CalcFormula = count ("LGX ZMO Service & Warranty Hdr" where("LGX ZMO Action Taken" = const(Repaired)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "LGX ZMO Warr. Stat. - Replaced"; Integer)
        {
            Caption = 'Warranty Status - Replaced';
            CalcFormula = count ("LGX ZMO Service & Warranty Hdr" where("LGX ZMO Action Taken" = const(Replaced)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(PK; "LGX ZMO Primary Key")
        {
        }
    }
}

