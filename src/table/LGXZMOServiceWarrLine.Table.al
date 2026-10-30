table 50001 "LGX ZMO Service & Warr. Line"
{
    DataClassification = CustomerContent;
    Caption = 'Service & Warranty Line';

    fields
    {
        field(1; "LGX ZMO Incident No."; Code[20])
        {
            Caption = 'Incident No.';
            DataClassification = CustomerContent;
        }
        field(2; "LGX ZMO Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }
        field(3; "LGX ZMO Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(4; "LGX ZMO Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;
        }
        field(6; "LGX ZMO Sale Date"; Date)
        {
            Caption = 'Sale Date';
            DataClassification = CustomerContent;
        }
        field(12; "LGX ZMO Assisted By"; Code[50])
        {
            Caption = 'Assisted By';
            DataClassification = CustomerContent;
        }
        field(13; "LGX ZMO Incident Date"; Date)
        {
            Caption = 'Incident Date';
            DataClassification = CustomerContent;
        }
        field(50; "LGX ZMO Service"; Option)
        {
            Caption = 'Service';
            DataClassification = CustomerContent;
            OptionCaption = '" ,Yes,No,Replaced"';
            OptionMembers = " ",Yes,No,Replaced;
        }
        field(51; "LGX ZMO Service Company No."; Code[20])
        {
            TableRelation = Vendor where("LGX ZMO Service Company" = const(true));
            DataClassification = CustomerContent;
            Caption = 'Service Company No.';

            trigger OnValidate();
            begin
                if Vendor.Get("LGX ZMO Service Company No.") then begin
                    "LGX ZMO Service Company Name" := Vendor.Name;
                    "LGX ZMO Service Company Name 2" := Vendor."Name 2";
                    "LGX ZMO Serv. Company Address" := Vendor.Address;
                    "LGX ZMO Serv. Company Addr. 2" := Vendor."Address 2";
                    "LGX ZMO Service Company City" := Vendor.City;
                    "LGX ZMO Serv. Comp. Post Code" := Vendor."Post Code";
                    "LGX ZMO Service Company County" := Vendor.County;
                    "LGX ZMO Serv. Comp. Ctry. Code" := Vendor."Country/Region Code";
                    "LGX ZMO Serv. Company Contact" := Vendor.Contact;
                    "LGX ZMO Serv. Comp. Phone No." := Vendor."Phone No.";
                    "LGX ZMO Serv. Comp. Fax No." := Vendor."Fax No.";
                    "LGX ZMO Service Company E-Mail" := Vendor."E-Mail";
                end;
            end;
        }
        field(52; "LGX ZMO Service Company Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Company Name';
        }
        field(53; "LGX ZMO Service Company Name 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Company Name 2';
        }
        field(54; "LGX ZMO Serv. Company Address"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Company Address';
        }
        field(55; "LGX ZMO Serv. Company Addr. 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Company Address';
        }
        field(56; "LGX ZMO Service Company City"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Company City';
            TableRelation = "Post Code".City;
            ValidateTableRelation = false;
        }
        field(57; "LGX ZMO Serv. Comp. Post Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Company Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(58; "LGX ZMO Service Company County"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Company County';
        }
        field(59; "LGX ZMO Serv. Comp. Ctry. Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Company Country Code';
            TableRelation = "Country/Region";
        }
        field(60; "LGX ZMO Serv. Company Contact"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Company Contact';
        }
        field(61; "LGX ZMO Serv. Comp. Phone No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Company Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(62; "LGX ZMO Serv. Comp. Fax No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Company Fax No.';
            ExtendedDatatype = PhoneNo;
        }
        field(63; "LGX ZMO Service Company E-Mail"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Company E-Mail';
            ExtendedDatatype = EMail;
        }
        field(64; "LGX ZMO Serv. Comp. Inv. No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Company Invoice No.';
        }
        field(78; "LGX ZMO Sell-To Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-To Customer No.';
        }
        field(91; "LGX ZMO Sell-to Contact"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact';
        }
        field(95; "LGX ZMO Cycles"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Cycles';
        }
        field(151; "LGX ZMO Remarks"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Remarks';
        }
        field(152; "LGX ZMO Courtesy Part"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Courtesy Part';
        }
        field(200; "LGX ZMO Package Tracking No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Package Tracking No.';
        }
        field(201; "LGX ZMO Schd. Delivery Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Scheduled Delivery Date';
        }
        field(202; "LGX ZMO Est. Delivery Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Estimated Delivery Date';
        }
        field(203; "LGX ZMO Actual Delivery Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Actual Delivery Date';
        }
        field(204; "LGX ZMO Left At"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Left At';
        }
        field(205; "LGX ZMO Received By"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Received By';
        }
        field(212; "LGX ZMO Shipment Method Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(213; "LGX ZMO Shipping Agent Code"; Code[10])
        {
            DataClassification = CustomerContent;
            AccessByPermission = TableData 5790 = R;
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(214; "LGX ZMO Shipment Return"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Shipment Return';
        }
        field(215; "LGX ZMO Reason Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Reason Code';
            TableRelation = "Return Reason";
        }
    }

    keys
    {
        key(PK; "LGX ZMO Incident No.", "LGX ZMO Line No.")
        {
        }
    }

    trigger OnInsert();
    begin
        if ServiceWarHeader.GET("LGX ZMO Incident No.") then begin
            "LGX ZMO Serial No." := ServiceWarHeader."LGX ZMO Serial No.";
            "LGX ZMO Sell-To Customer No." := ServiceWarHeader."LGX ZMO Sell-To Customer No.";
            "LGX ZMO Item No." := ServiceWarHeader."LGX ZMO Item No.";
        end;
    end;

    var
        Vendor: Record "Vendor";
        ServiceWarHeader: Record "LGX ZMO Service & Warranty Hdr";
}
