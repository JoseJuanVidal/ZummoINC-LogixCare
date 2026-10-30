table 50000 "LGX ZMO Service & Warranty Hdr"
{
    DataClassification = CustomerContent;
    Caption = 'Service & Warranty Header';
    LookupPageID = "LGX ZMO Service & Warr. List";
    Permissions = TableData "Loaner Entry" = d,
                  TableData "Service Order Allocation" = rimd;

    fields
    {
        field(3; "LGX ZMO Incident No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Incident No.';

            trigger OnValidate();
            begin
                if "LGX ZMO Incident No." <> xRec."LGX ZMO Incident No." then begin
                    SalesSetup.Get();
                    TestNoSeriesManual();
                    "LGX ZMO No. Series" := '';
                end;
            end;
        }
        field(10; "LGX ZMO Serial No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Serial No.';

            trigger OnValidate()
            var
                PostedAssembletoOrderLink: Record "Posted Assemble-to-Order Link";
                SalesShipmentLine: Record "Sales Shipment Line";
            begin
                CheckSerialNo("LGX ZMO Serial No.");

                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetCurrentKey("Serial No.");
                ItemLedgerEntry.SetRange("Serial No.", "LGX ZMO Serial No.");
                ItemLedgerEntry.SetFilter("Remaining Quantity", '<>%1', 0);
                ItemLedgerEntry.SetRange(Open, true);
                If ItemLedgerEntry.FindFirst() then
                    ERROR('Item %1 with Serial No. %2 is currently available in %3 Location', ItemLedgerEntry."Item No.", ItemLedgerEntry."Serial No.", ItemLedgerEntry."Location Code");

                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetCurrentKey("Serial No.");
                ItemLedgerEntry.SetRange("Serial No.", "LGX ZMO Serial No.");
                ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
                If ItemLedgerEntry.FindFirst() then begin
                    "LGX ZMO Sales Shipment No." := ItemLedgerEntry."Document No.";
                    "LGX ZMO Purchase Date" := ItemLedgerEntry."Posting Date";
                    Validate("LGX ZMO Sell-To Customer No.", ItemLedgerEntry."Source No.");
                    Validate("LGX ZMO Item No.", ItemLedgerEntry."Item No.");
                end;

                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetCurrentKey("Serial No.");
                ItemLedgerEntry.SetRange("Serial No.", "LGX ZMO Serial No.");
                ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
                If ItemLedgerEntry.FindFirst() then begin
                    "LGX ZMO Purchase Receipt No." := ItemLedgerEntry."Document No.";
                    Validate("LGX ZMO Vendor No.", ItemLedgerEntry."Source No.");
                end;

                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetCurrentKey("Serial No.");
                ItemLedgerEntry.SetRange("Serial No.", "LGX ZMO Serial No.");
                ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Posted Assembly");
                ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::"Assembly Consumption");
                If ItemLedgerEntry.FindFirst() then
                    if PostedAssembletoOrderLink.Get(PostedAssembletoOrderLink."Assembly Document Type"::Assembly, ItemLedgerEntry."Document No.") then
                        if SalesShipmentLine.Get(PostedAssembletoOrderLink."Document No.", PostedAssembletoOrderLink."Document Line No.") then begin
                            "LGX ZMO Sales Shipment No." := SalesShipmentLine."Document No.";
                            "LGX ZMO Purchase Date" := ItemLedgerEntry."Posting Date";
                            Validate("LGX ZMO Sell-To Customer No.", SalesShipmentLine."Sell-to Customer No.");
                            Validate("LGX ZMO Item No.", ItemLedgerEntry."Item No.");
                            exit;
                        end;
            end;
        }
        field(11; "LGX ZMO Sales Shipment No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Shipment No.';
        }
        field(12; "LGX ZMO Purchase Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Date';
        }
        field(13; "LGX ZMO Incident Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Incident Date';
        }
        field(14; "LGX ZMO Closed Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Closed Date';
        }
        field(15; "LGX ZMO Warranty"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Warranty';

            trigger OnValidate()
            begin
                CheckItemLinePrice();
            end;
        }
        field(16; "LGX ZMO Action Taken"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Action Taken';
            OptionCaption = 'No Action,Repaired,Replaced';
            OptionMembers = "No Action",Repaired,Replaced;

            trigger OnValidate()
            begin
                if Rec."LGX ZMO Action Taken" <> xRec."LGX ZMO Action Taken" then
                    if Rec."LGX ZMO Action Taken" in [Rec."LGX ZMO Action Taken"::"No Action", Rec."LGX ZMO Action Taken"::Repaired] then
                        Rec."LGX ZMO New Serial No." := '';
            end;
        }
        field(17; "LGX ZMO New Serial No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'New Serial No.';
        }
        field(18; "LGX ZMO Sales Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Invoice No.';
        }
        field(19; "LGX ZMO Warranty Expiry Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Warranty Expiry Date';
        }
        field(51; "LGX ZMO Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';

            trigger OnValidate();
            begin
                If Item.Get("LGX ZMO Item No.") then begin
                    "LGX ZMO Item Description" := Item.Description;
                    "LGX ZMO Item Description 2" := Item."Description 2";
                end;
            end;
        }
        field(52; "LGX ZMO Item Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Description';
        }
        field(53; "LGX ZMO Item Description 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Description 2';
        }
        field(78; "LGX ZMO Sell-To Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-To Customer No.';

            trigger OnValidate();
            begin
                SalesShipmentHeader.Reset();
                SalesShipmentHeader.SetRange("Sell-to Customer No.", "LGX ZMO Sell-To Customer No.");
                If SalesShipmentHeader.FindFirst() then begin
                    "LGX ZMO Sell-to Customer Name" := SalesShipmentHeader."Sell-to Customer Name";
                    "LGX ZMO Sell-to Cust. Name 2" := SalesShipmentHeader."Sell-to Customer Name 2";
                    "LGX ZMO Sell-to Address" := SalesShipmentHeader."Sell-to Address";
                    "LGX ZMO Sell-to Address 2" := SalesShipmentHeader."Sell-to Address 2";
                    "LGX ZMO Sell-to City" := SalesShipmentHeader."Sell-to City";
                    "LGX ZMO Sell-to Post Code" := SalesShipmentHeader."Sell-to Post Code";
                    "LGX ZMO Sell-to County" := SalesShipmentHeader."Sell-to County";
                    "LGX ZMO Sell-to C./R. Code" := SalesShipmentHeader."Sell-to Country/Region Code";
                    "LGX ZMO Sell-to Contact" := SalesShipmentHeader."Sell-to Contact";

                    "LGX ZMO Package Tracking No." := SalesShipmentHeader."Package Tracking No.";
                    "LGX ZMO Shipment Date" := SalesShipmentHeader."Shipment Date";
                    "LGX ZMO Shipment Method Code" := SalesShipmentHeader."Shipment Method Code";
                    "LGX ZMO Shipping Agent Code" := SalesShipmentHeader."Shipping Agent Code";

                    "LGX ZMO Ship-to Code" := SalesShipmentHeader."Ship-to Code";
                    "LGX ZMO Ship-to Name" := SalesShipmentHeader."Ship-to Name";
                    "LGX ZMO Ship-to Name 2" := SalesShipmentHeader."Ship-to Name 2";
                    "LGX ZMO Ship-to Address" := SalesShipmentHeader."Ship-to Address";
                    "LGX ZMO Ship-to Address 2" := SalesShipmentHeader."Ship-to Address 2";
                    "LGX ZMO Ship-to City" := SalesShipmentHeader."Ship-to City";
                    "LGX ZMO Ship-to Contact" := SalesShipmentHeader."Ship-to Contact";
                    "LGX ZMO Ship-to Post Code" := SalesShipmentHeader."Ship-to Post Code";
                    "LGX ZMO Ship-to County" := SalesShipmentHeader."Ship-to County";
                    "LGX ZMO Ship-to C./R. Code" := SalesShipmentHeader."Ship-to Country/Region Code";
                end;
            end;
        }
        field(79; "LGX ZMO Sell-to Customer Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Customer Name';

            trigger OnValidate();
            begin
                "LGX ZMO Sell-to Customer Name" := UpperCase("LGX ZMO Sell-to Customer Name");
            end;
        }
        field(80; "LGX ZMO Sell-to Cust. Name 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Customer Name 2';
        }
        field(81; "LGX ZMO Sell-to Address"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Address';
        }
        field(82; "LGX ZMO Sell-to Address 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Address 2';
        }
        field(83; "LGX ZMO Sell-to City"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to City';
            TableRelation = "Post Code".City;
            ValidateTableRelation = false;
        }
        field(88; "LGX ZMO Sell-to Post Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Postal/ZIP Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(89; "LGX ZMO Sell-to County"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Province/State';
        }
        field(90; "LGX ZMO Sell-to C./R. Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(91; "LGX ZMO Sell-to Contact"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact';
        }
        field(92; "LGX ZMO Sell-to Phone No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(93; "LGX ZMO Sell-to Fax No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Fax No.';
        }
        field(94; "LGX ZMO Sell-to E-Mail"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Email';
            ExtendedDatatype = EMail;
        }
        field(107; "LGX ZMO No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(120; "LGX ZMO Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            OptionCaption = 'Opened,Parts Shipped,Service Scheduled,Delayed,Closed';
            OptionMembers = Opened,"Parts Shipped","Service Scheduled",Delayed,Closed;

            trigger OnValidate()
            begin
                IF "LGX ZMO Status" = "LGX ZMO Status"::Closed then
                    "LGX ZMO Closed Date" := Today();
                CheckCloseService();
            end;
        }
        field(150; "LGX ZMO Purchase Receipt No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Receipt No.';
        }
        field(151; "LGX ZMO Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.';

            trigger OnValidate();
            begin
                If Vendor.Get("LGX ZMO Vendor No.") then
                    "LGX ZMO Vendor Name" := Vendor.Name;
            end;
        }
        field(152; "LGX ZMO Vendor Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Name';
        }
        field(153; "LGX ZMO Purchase Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Invoice No.';

            trigger OnValidate();
            begin
                ShowItemPurchInvLines();
            end;
        }
        field(200; "LGX ZMO Package Tracking No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Package Tracking No.';
        }
        field(201; "LGX ZMO Ship-to Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Code';
        }
        field(202; "LGX ZMO Ship-to Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Name';
        }
        field(203; "LGX ZMO Ship-to Name 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Name 2';
        }
        field(204; "LGX ZMO Ship-to Address"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Address';
        }
        field(205; "LGX ZMO Ship-to Address 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Address 2';
        }
        field(206; "LGX ZMO Ship-to City"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to City';
            TableRelation = "Post Code".City;
            ValidateTableRelation = false;
        }
        field(207; "LGX ZMO Ship-to Contact"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Contact';
        }
        field(208; "LGX ZMO Ship-to Post Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Postal/ZIP Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(209; "LGX ZMO Ship-to County"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Province/State';
        }
        field(210; "LGX ZMO Ship-to C./R. Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(211; "LGX ZMO Shipment Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Shipment Date';
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
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        // Antes en Zummo Ext WARRANTY (tableextension 50062)
        field(50000; "Service Type"; code[20])
        {
            // tipo pedido servicio
            DataClassification = CustomerContent;
            Caption = 'Service Type';
            TableRelation = "ZM Service Order Type".Code where(Type = const("Service Order Type"));
        }
        field(50001; "Fault"; code[20])
        {
            // Fallo
            DataClassification = CustomerContent;
            Caption = 'Fault';
            TableRelation = "ZM Service Order Type".Code where(Type = const(Fault));
        }
        field(50002; "Localized Fault"; code[20])
        {
            // Fallo localizado
            DataClassification = CustomerContent;
            Caption = 'Localized Fault';
            TableRelation = if (Fault = const('')) "ZM Service Order Type".Code where(Type = const("Localized Fault")) else
            "ZM Service Order Type".Code where(Type = const("Localized Fault"), Code2 = field(Fault));

            trigger OnValidate()
            begin
                Validate_FaultLocationSpain();
            end;
        }
        field(50003; "Cotization Date"; date)
        {
            Caption = 'Cotization Date';
        }
        field(50005; "Shipphing Method"; Option)
        {
            Caption = 'Shipphing Method';
            OptionMembers = "Client Pick-Up","Tech Deliver",Freight,"UPS Ground","UPS Next Day Air","UPS 2nd Day Air","UPS Next Day Air Saver","UPS 2nd Day Air A.M.";
            OptionCaption = 'Client Pick-Up,Tech Deliver,Freight,UPS Ground,UPS Next Day Air,UPS 2nd Day Air,UPS Next Day Air Saver,UPS 2nd Day Air A.M.';
        }
        field(50006; "Service Company"; text[100])
        {
            Caption = 'Service Company';
        }
        field(50007; "Shipping Amount"; Decimal)
        {
            Caption = 'Shipping Amount';
        }
        field(50008; "Labor Hours Quantity"; Decimal)
        {
            Caption = 'Labor Hours Quantity';

            trigger OnValidate()
            begin
                UpdateLaborsFees();
            end;
        }
        field(50009; "Travel Hours Quantity"; Decimal)
        {
            Caption = 'Labor Hours Quantity';
            trigger OnValidate()
            begin
                UpdateTravelFees();
            end;
        }
        field(50010; "Labor Hours Fees"; Decimal)
        {
            Caption = 'Labor Hours Fees';
            Editable = false;
        }
        field(50011; "Travel Hours Fees"; Decimal)
        {
            caption = 'Round trip travel hours';
            Editable = false;
        }
        field(50012; "Credit Card Fees"; Decimal)
        {
            Caption = 'Credit Card Fees (3.50 %)';
        }
        field(50014; "Rush Fees"; Decimal)
        {
            Caption = 'Rush Fees';
        }
        field(50015; "Amount Taxes"; Decimal)
        {
            Caption = 'Amount Taxes';
        }
        field(50016; DiscountPorc; Decimal)
        {
            Caption = 'Discount %';

            trigger OnValidate()
            begin
                ValidateDiscount();
            end;
        }
        field(50017; "Amount Discount"; Decimal)
        {
            Caption = 'Amount Discount';
            Editable = false;

            trigger OnValidate()
            begin
                if Rec."Amount Discount" = xRec."Amount Discount" then
                    exit;
                Rec.DiscountPorc := 0;
            end;
        }
        field(50018; Taxes; Boolean)
        {
            Caption = 'Taxes';

            trigger OnValidate()
            begin
                Rec."Amount Taxes" := 0;
                if Rec.Taxes then
                    Calculate_Taxes();
            end;
        }
        field(50020; "Items Amount"; decimal)
        {
            Caption = 'Items Amount';
            FieldClass = FlowField;
            CalcFormula = sum("ZM Serv & Warr Items".Amount where("LGX ZMO Incident No." = field("LGX ZMO Incident No.")));
            Editable = False;
        }
        field(50022; Response; code[500])
        {
            Caption = 'Response';
            Editable = false;
        }
        field(50024; "Service Order"; code[20])
        {
            Caption = 'Service Order';
            Editable = false;
        }
        field(50026; "Credit Memo No."; code[20])
        {
            Caption = 'Credit Memo No.';
            Editable = false;
        }
        field(50028; "Response Text"; text[250])
        {
            Caption = 'Response Text';
        }
        field(50030; "Cost Total"; Decimal)
        {
            Caption = 'Cost Total';
            FieldClass = FlowField;
            CalcFormula = sum("ZM Serv & Warr Items"."Unit Cost" where("LGX ZMO Incident No." = field("LGX ZMO Incident No.")));
            Editable = False;
        }
        field(50040; "Items No."; Integer)
        {
            Caption = 'Items No.';
            FieldClass = FlowField;
            CalcFormula = count("ZM Serv & Warr Items" where("LGX ZMO Incident No." = field("LGX ZMO Incident No.")));
            Editable = False;
        }
        field(50100; "LGX ZMO Ship-to E-Mail"; text[80])
        {
            Caption = 'Ship-to E-Mail';
        }
        field(50110; "LGX ZMO Ship-to Phone"; text[80])
        {
            Caption = 'Ship-to E-Mail';
        }
        field(50050; "Create Date-Time"; DateTime)
        {
            Caption = 'Create Date-Time';
            Editable = false;
        }
        field(50051; "Sent Quote Date-Time"; DateTime)
        {
            Caption = 'Sent Quote Date-Time';
            Editable = false;
        }
        field(50052; "Orders Date-Time"; DateTime)
        {
            Caption = 'Orders Date-Time';
            Editable = false;
        }
        field(50055; "Technical Visit"; Option)
        {
            Caption = 'Technical Visit';
            OptionMembers = " ","Yes","No";
        }
        field(50056; "Actiont Type"; Option)
        {
            Caption = 'Actiont Type';
            OptionMembers = " ","Bench PO","Commercial Courtesy";
        }
        field(50057; "Resolution"; Option)
        {
            Caption = 'Resolution';
            OptionMembers = " ","Resolved by Phone","Quote Operations";
        }
        field(50058; "Sent Return Order Date-Time"; DateTime)
        {
            Caption = 'Sent Return Order Date-Time';
            Editable = false;
        }
        field(50068; "Parts/Machine"; Option)
        {
            caption = 'Parts/Marchine';
            OptionMembers = "Machine","Parts";
        }
        field(50069; "Service & Warranty Associated"; code[20])
        {
            TableRelation = "LGX ZMO Service & Warranty Hdr"."LGX ZMO Incident No.";
        }
        field(50080; "User ID"; code[50])
        {
        }
    }

    keys
    {
        key(PK; "LGX ZMO Incident No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "LGX ZMO Incident No.", "LGX ZMO Sell-To Customer No.", "LGX ZMO Sell-to Customer Name", "LGX ZMO Item No.", "LGX ZMO Status")
        {
        }
        fieldgroup(Brick; "LGX ZMO Incident No.", "LGX ZMO Sell-To Customer No.", "LGX ZMO Sell-to Customer Name", "LGX ZMO Item No.", "LGX ZMO Status")
        {
        }
    }

    trigger OnDelete();
    begin
        ServiceWarrantyLine.Reset();
        ServiceWarrantyLine.SetRange("LGX ZMO Incident No.", "LGX ZMO Incident No.");
        ServiceWarrantyLine.DeleteAll();
        CheckDeleteServWarrant();
    end;

    trigger OnInsert();
    begin
        SalesSetup.Get();
        If "LGX ZMO Incident No." = '' then begin
            TestNoSeries();
            NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."LGX ZMO No. Series", 0D, "LGX ZMO Incident No.", "LGX ZMO No. Series");
        end;

        "LGX ZMO Incident Date" := Today();
        ModifyRecord();
    end;

    trigger OnModify()
    begin
        ModifyRecord();
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        ServiceWarHeader: Record "LGX ZMO Service & Warranty Hdr";
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesShipmentHeader: Record "Sales Shipment Header";
        ServiceWarrantyLine: Record "LGX ZMO Service & Warr. Line";
        Vendor: Record "Vendor";
        Item: Record "Item";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        Text50001Txt: Label 'The service %1 already exists.';
        // Antes en Zummo Ext WARRANTY (tableextension 50062)
        UserSetup: Record "User Setup";
        LGXZMOServiceWarrLine: Record "LGX ZMO Service & Warr. Line";
        ServiceWarrComment: Record "LGX ZMO Service Warr. Comment";
        ServiceWarrantItemsLine: Record "ZM Serv & Warr Items";
        LblDelete: Label 'Cannot deleted there are lines in table %1';
        lblClose: Label 'Cannot close Services without Reason Code';
        lblTechnicalVisit: Label 'You must enter the option for %1';

    procedure AssistEdit(OldServiceWarHeader: Record "LGX ZMO Service & Warranty Hdr"): Boolean;
    var
        ServiceWarHeader2: Record "LGX ZMO Service & Warranty Hdr";
    begin
        With ServiceWarHeader do begin
            Copy(Rec);
            SalesSetup.Get();
            TestNoSeries();
            If NoSeriesMgt.SelectSeries(GetNoSeriesCode(), OldServiceWarHeader."LGX ZMO No. Series", "LGX ZMO No. Series") then begin
                NoSeriesMgt.SetSeries("LGX ZMO Incident No.");
                If ServiceWarHeader2.Get("LGX ZMO Incident No.") then
                    Error(Text50001Txt, LOWERCASE("LGX ZMO Incident No."));
                Rec := ServiceWarHeader;
                exit(true);
            end;
        end;
    end;

    local procedure TestNoSeries();
    begin
        SalesSetup.TestField("LGX ZMO Serv. & Warranty Nos.");
    end;

    local procedure GetNoSeriesCode(): Code[20];
    begin
        exit(SalesSetup."LGX ZMO Serv. & Warranty Nos.");
    end;

    local procedure TestNoSeriesManual();
    begin
        NoSeriesMgt.TestManual(SalesSetup."LGX ZMO Serv. & Warranty Nos.");
    end;

    procedure ReadFromExternalDatabase(SerialNo: Variant);
    var
    /* ADOConnection: Automation "{2A75196C-D9EB-4129-B803-931327F72D5C} 2.8:{00000514-0000-0010-8000-00AA006D2EA4}:'Microsoft ActiveX Data Objects 2.8 Library'.Connection";
    ADOCommand: Automation "{2A75196C-D9EB-4129-B803-931327F72D5C} 2.8:{00000507-0000-0010-8000-00AA006D2EA4}:'Microsoft ActiveX Data Objects 2.8 Library'.Command";
    ADOParameter: Automation "{2A75196C-D9EB-4129-B803-931327F72D5C} 2.8:{0000050B-0000-0010-8000-00AA006D2EA4}:'Microsoft ActiveX Data Objects 2.8 Library'.Parameter";
    ADORecSet: Automation "{2A75196C-D9EB-4129-B803-931327F72D5C} 2.8:{00000535-0000-0010-8000-00AA006D2EA4}:'Microsoft ActiveX Data Objects 2.8 Library'.Recordset";
    adoField: Automation "{2A75196C-D9EB-4129-B803-931327F72D5C} 2.8:{00000569-0000-0010-8000-00AA006D2EA4}:'Microsoft ActiveX Data Objects 2.8 Library'.Field";
    connString: Text[1024];
    activeConnection: Variant;
    salesLineStr: Text[1024];
    idx: Integer;
    adoValue: Variant;
    adoType: Integer;
    ADOStream: Automation "{2A75196C-D9EB-4129-B803-931327F72D5C} 2.8:{00000566-0000-0010-8000-00AA006D2EA4}:'Microsoft ActiveX Data Objects 2.8 Library'.Stream";
    SQLString: Text[1024];
    RecordsAffected: Integer;
    RSOption: Integer; */
    begin
        /* Clear("Sales Invoice No.");
        Clear("Sales Shipment No.");
        Clear("Shipment Date");
        Clear("Purchase Date");
        Clear("Warranty Expiry Date");
        Clear("Package Tracking No.");
        Clear("Sell-to Customer Name");
        Clear("Sell-to Customer Name 2");
        Clear("Sell-to Address");
        Clear("Sell-to Address 2");
        Clear("Sell-to City");
        Clear("Sell-to County");
        Clear("Sell-to Post Code");
        //Clear("Sell-to Country/Region Code");
        //Clear("Ship-to Name");
        //Clear("Ship-to Name 2");
        Clear("Ship-to Address");
        Clear("Ship-to Address 2");
        Clear("Ship-to City");
        Clear("Ship-to County");
        Clear("Ship-to Post Code");
        //Clear("Ship-to Country/Region Code");
        Clear("Item No.");
        Clear("Item Description");
        Clear("Item Description 2");
        Clear("Purchase Receipt No.");

        //connString := 'Driver={SQL Server};SERVER=ZUMMOSVR-01\ALLORDERS;DATABASE=ZUMMOINC12-20-2011';
        connString := 'Driver={SQL Server};SERVER=ZUMMOSVR-01\ALLORDERS;DATABASE=ZUMMOINC12-20-2011;UID=SA;PWD=Logix123!';
        begin
            If ISClear(ADOConnection) then
                CREATE(ADOConnection, FALSE, true);

            If ISClear(ADORecSet) then
                CREATE(ADORecSet, FALSE, true);

            If ISClear(ADOStream) then begin
                If NOT CREATE(ADOStream, FALSE, true) then begin
                    ERROR('Cannot create ADO Stream automation variable.');
                end;
            end;
            ADOConnection.Open(connString);
            //MESSAGE('Conneciton Created');
        end;

        //SQLString := 'SELECT [Customer],[Invoice No] as InvoiceNo,[Lot-Serial No] ' + 'FROM [dbo].[qryLabItemsShippedWithSerialNos] where [Lot-Serial No] = ' + '''' + Format(SerialNo) + '''';
        SQLString :=
          'SELECT [Tran Type],[Doc No],[Customer],[Ship from],[Ship To],[ShipDate],[Ship Method],[Ship Doc Ref],[FOB],[Weight],[Packages],[Shipped],[Customer PO],[Term],[Invoice No] as InvoiceNo,'
        + '[Customer CompanyName],[BillAddr1],[BillAddr2],[BillAddr3],[BillCity],[BillState],[BillZip],[BillCountry],[ShipAddr1],[ShipAddr2],[ShipAddr3],[ShipCity],[ShipState],[ShipZip],[ShipCountry],'
        + '[Line No],[Item],[Item Description],[UOM],[Sales Order],[Price],[Item Short Name],[Bin],[VendorPartNumber],[MftgPartNumber],[Lot-Serial No],[Quantity],[LotSerialNoExpiry],'
        + '[CompanyName],[CompanyAddr1],[CompanyAddr2],[CompanyAddr3],[CompanyCity],[CompanyCountry],[CompanyEmail],[CompanyFax],[CompanyPhone],[CompanyPostalCode],[CompanyState]'
        + 'FROM [dbo].[qryLabItemsShippedWithSerialNos] where [Lot-Serial No] = ' + '''' + Format(SerialNo) + ''' AND [Price] <> 0 AND [Tran Type] = ''Shipping''';

        ADORecSet := ADOConnection.Execute(SQLString, RecordsAffected, RSOption);

        If (ADORecSet.BOF) AND (ADORecSet.EOF) then begin
            MESSAGE('Product Records Not Found');
        end else begin
            ADORecSet.MoveFirst;
            repeat
                //  "Serial No." := ADORecSet.Fields.Item('Lot-Serial No').Value;
                "Sales Invoice No." := Format(ADORecSet.Fields.Item('InvoiceNo').Value);
                "Sales Shipment No." := Format(ADORecSet.Fields.Item('Sales Order').Value);
                "Shipment Date" := DT2DATE(ADORecSet.Fields.Item('ShipDate').Value);
                "Purchase Date" := DT2DATE(ADORecSet.Fields.Item('ShipDate').Value);
                "Warranty Expiry Date" := DT2DATE(ADORecSet.Fields.Item('LotSerialNoExpiry').Value);
                "Package Tracking No." := ADORecSet.Fields.Item('Ship Doc Ref').Value;
                "Sell-to Customer Name" := ADORecSet.Fields.Item('Customer').Value;
                "Sell-to Customer Name 2" := ADORecSet.Fields.Item('Customer CompanyName').Value;
                "Sell-to Address" := ADORecSet.Fields.Item('BillAddr1').Value;
                "Sell-to Address 2" := ADORecSet.Fields.Item('BillAddr2').Value;
                "Sell-to City" := ADORecSet.Fields.Item('BillCity').Value;
                "Sell-to County" := ADORecSet.Fields.Item('BillState').Value;
                "Sell-to Post Code" := ADORecSet.Fields.Item('BillZip').Value;
                //"Sell-to Country/Region Code" := ADORecSet.Fields.Item('BillCountry').Value;
                //"Ship-to Name" := ADORecSet.Fields.Item('BillZip').Value;
                //"Ship-to Name 2" := ADORecSet.Fields.Item('BillZip').Value;
                "Ship-to Address" := ADORecSet.Fields.Item('ShipAddr1').Value;
                "Ship-to Address 2" := ADORecSet.Fields.Item('ShipAddr1').Value;
                "Ship-to City" := ADORecSet.Fields.Item('ShipCity').Value;
                "Ship-to County" := ADORecSet.Fields.Item('ShipState').Value;
                "Ship-to Post Code" := ADORecSet.Fields.Item('ShipZip').Value;
                //"Ship-to Country/Region Code" := ADORecSet.Fields.Item('ShipCountry').Value;
                "Item No." := ADORecSet.Fields.Item('Item').Value;
                "Item Description" := ADORecSet.Fields.Item('Item Description').Value;
                "Item Description 2" := ADORecSet.Fields.Item('Item Short Name').Value;
                "Purchase Receipt No." := ADORecSet.Fields.Item('Customer PO').Value;
                ADORecSet.MoveNext();
            until ADORecSet.EOF;
        end;
        ADOConnection.Close;
        MESSAGE('Search completed and External Connection closed'); */
    end;

    local procedure CheckSerialNo(SerialNo: Code[20]);
    var
        LocalServiceWarHeader: Record "LGX ZMO Service & Warranty Hdr";
    begin
        LocalServiceWarHeader.Reset();
        LocalServiceWarHeader.SetRange("LGX ZMO Warranty", true);
        LocalServiceWarHeader.SetRange("LGX ZMO Serial No.", SerialNo);
        If not LocalServiceWarHeader.IsEmpty() then
            Message('This serial number has been already served');
    end;

    local procedure FilterPstdDocLnItemLedgEntries(var ItemLedgEntry: Record "Item Ledger Entry");
    begin
        ItemLedgEntry.Reset();
        ItemLedgEntry.SetCurrentKey("Document No.");
        ItemLedgEntry.SetRange("Document No.", "LGX ZMO Purchase Receipt No.");
        ItemLedgEntry.SetRange("Document Type", ItemLedgEntry."Document Type"::"Purchase Receipt");
        ItemLedgEntry.SetRange("Serial No.", "LGX ZMO Serial No.");
    end;

    local procedure ShowItemPurchInvLines();
    var
        TempPurchInvLine: Record "Purch. Inv. Line" temporary;
    begin

        If "LGX ZMO Purchase Receipt No." <> '' then begin
            GetPurchInvLines(TempPurchInvLine);
            PAGE.RUNMODAL(PAGE::"Posted Purchase Invoice Lines", TempPurchInvLine);
        end;
    end;

    local procedure GetPurchInvLines(var TempPurchInvLine: Record "Purch. Inv. Line" temporary);
    var
        PurchInvLine: Record "Purch. Inv. Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
    begin
        TempPurchInvLine.Reset();
        TempPurchInvLine.DeleteAll();

        If "LGX ZMO Purchase Receipt No." = '' then
            exit;

        FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
        ItemLedgEntry.SetFilter("Invoiced Quantity", '<>0');
        If ItemLedgEntry.FindSet() then begin
            ValueEntry.SetCurrentKey("Item Ledger Entry No.", "Entry Type");
            ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
            ValueEntry.SetFilter("Invoiced Quantity", '<>0');
            repeat
                ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
                If ValueEntry.FindSet() then
                    repeat
                        If ValueEntry."Document Type" = ValueEntry."Document Type"::"Purchase Invoice" then
                            If PurchInvLine.Get(ValueEntry."Document No.", ValueEntry."Document Line No.") then begin
                                TempPurchInvLine.Init();
                                TempPurchInvLine := PurchInvLine;
                                If TempPurchInvLine.Insert() then;
                            end;
                    until ValueEntry.Next() = 0;
            until ItemLedgEntry.Next() = 0;
        end;
    end;

    local procedure ModifyRecord()
    begin
        if Rec."Create Date-Time" = 0DT then
            Rec."Create Date-Time" := CurrentDateTime();
        if Rec."User ID" = '' then
            Rec."User ID" := UserId;
    end;

    local procedure CheckDeleteServWarrant()
    begin
        LGXZMOServiceWarrLine.Reset();
        LGXZMOServiceWarrLine.SetRange("LGX ZMO Incident No.", Rec."LGX ZMO Incident No.");
        if LGXZMOServiceWarrLine.FindSet() then
            Error(LblDelete, LGXZMOServiceWarrLine.TableCaption);

        ServiceWarrComment.Reset();
        ServiceWarrComment.SetRange("LGX ZMO No.", Rec."LGX ZMO Incident No.");
        if ServiceWarrComment.FindSet() then
            Error(LblDelete, ServiceWarrComment.TableCaption);

        ServiceWarrantItemsLine.Reset();
        ServiceWarrantItemsLine.SetRange("LGX ZMO Incident No.", Rec."LGX ZMO Incident No.");
        if ServiceWarrantItemsLine.FindSet() then
            Error(LblDelete, ServiceWarrantItemsLine.TableCaption);

    end;

    local procedure CheckCloseService()
    var
        myInt: Integer;
    begin
        if Rec."LGX ZMO Status" in [Rec."LGX ZMO Status"::Closed] then begin
            WarrantyLinesChecksReasonCode();

            if Rec."Technical Visit" in [Rec."Technical Visit"::" "] then
                Error(lblTechnicalVisit, Rec.FieldCaption("Technical Visit"));

            if Rec."LGX ZMO Action Taken" in [Rec."LGX ZMO Action Taken"::"No Action"] then
                Rec.TestField(Resolution);
            // Garantia de partes - solo opcion Replaced
            if Rec."LGX ZMO Warranty" and (Rec."Parts/Machine" in [Rec."Parts/Machine"::Parts]) then
                Rec.TestField("LGX ZMO Action Taken", Rec."LGX ZMO Action Taken"::Replaced);

            // si es Garantia de maquina con Replaced, indicar nuevo numero de serie
            if WarrantyMachineReplaced() then
                if Rec."LGX ZMO New Serial No." = '' then
                    Rec.TestField("LGX ZMO New Serial No.");
        end;
    end;

    local procedure WarrantyLinesChecksReasonCode()
    begin
        LGXZMOServiceWarrLine.Reset();
        LGXZMOServiceWarrLine.SetRange("LGX ZMO Incident No.", Rec."LGX ZMO Incident No.");
        LGXZMOServiceWarrLine.SetRange("LGX ZMO Reason Code", '');
        if LGXZMOServiceWarrLine.FindSet() then
            Error(lblClose, LGXZMOServiceWarrLine.FieldName("LGX ZMO Reason Code"));
    end;

    procedure WarrantyMachineReplaced(): Boolean
    var
        myInt: Integer;
    begin
        if Rec."LGX ZMO Warranty" and (Rec."Parts/Machine" in [Rec."Parts/Machine"::Machine])
                and (Rec."LGX ZMO Action Taken" in [Rec."LGX ZMO Action Taken"::Replaced]) then
            exit(true);
    end;

    procedure UserPermissionsstatistics(): Boolean
    var
        myInt: Integer;
    begin
        if UserSetup.Get(UserId) then
            exit(UserSetup."Allow statistics Serv. & Warr.");
    end;

    local procedure CheckItemLinePrice()
    var
        ServWarrItems: Record "ZM Serv & Warr Items";
        lblMsgWithPrice: Label 'There are Products lines with a price';
        lblMsgWithoutPrice: Label 'There are Products lines without a price';
    begin
        if not Rec."LGX ZMO Warranty" <> xRec."LGX ZMO Warranty" then
            exit;
        ServWarrItems.Reset();
        ServWarrItems.SetRange("LGX ZMO Incident No.", Rec."LGX ZMO Incident No.");
        ServWarrItems.SetFilter("Item No.", '<>%1', '');
        case Rec."LGX ZMO Warranty" of
            true:
                begin
                    ServWarrItems.SetFilter("Unit Price", '<>%1', 0);
                    if ServWarrItems.FindSet() then
                        Message(lblMsgwithPrice);
                end;
            else begin
                ServWarrItems.SetRange("Unit Price", 0);
                if ServWarrItems.FindSet() then
                    Message(lblMsgWithoutPrice);
            end;
        end;
        if ServWarrItems.FindFirst() then
            repeat
                ServWarrItems.UpdateUnitPrice();
                ServWarrItems.Modify();
            until ServWarrItems.Next() = 0;
    end;

    local procedure Validate_FaultLocationSpain()
    var
        Fault: Record "ZM Service Order Type";
    begin
        Fault.Reset();
        Fault.SetRange(Type, Fault.Type::"Localized Fault");
        Fault.SetRange(Code, Rec."Localized Fault");
        if Fault.FindFirst() then begin
            if Fault.Code2 <> Rec.Fault then begin
                Rec.Fault := Fault.Code2;
            end
        end;
    end;

    procedure GetItemsAmount(): Decimal
    var
        myInt: Integer;
    begin
        Rec.CalcFields("Items Amount");
        exit(Rec."Items Amount");
    end;

    procedure GetTotalsCharges(): Decimal
    var
        myInt: Integer;
    begin
        exit(Rec."Shipping Amount" + (Rec."Labor Hours Quantity" * Rec."Labor Hours Fees") +
                    (Rec."Travel Hours Quantity" * Rec."Travel Hours Fees") + Rec."Credit Card Fees" + Rec."Rush Fees");
    end;

    procedure GetTotals(): Decimal
    var
        myInt: Integer;
    begin
        exit(Rec."Items Amount" + Rec."Shipping Amount" + (Rec."Labor Hours Quantity" * Rec."Labor Hours Fees") +
                    (Rec."Travel Hours Quantity" * Rec."Travel Hours Fees") + Rec."Credit Card Fees" + Rec."Rush Fees" +
                    Rec."Amount Taxes" - Rec."Amount Discount");
    end;

    local procedure ValidateDiscount()
    var
        lblError: Label 'The discount %1 applied is higher than the discount allowed to the customer.';
    begin
        SalesSetup.Get();
        if SalesSetup."Maximum Discount" > 0 then
            if Rec.DiscountPorc > SalesSetup."Maximum Discount" then
                Error(lblError, Rec.DiscountPorc);
        Rec."Amount Discount" := 0;
        if Rec.DiscountPorc = 0 then
            exit;
        Rec."Amount Discount" := Round(Rec.GetItemsAmount() / Rec.DiscountPorc, 0.01);
    end;

    local procedure UpdateLaborsFees()
    var
        myInt: Integer;
    begin
        SalesSetup.Get();
        SalesSetup.TestField("Labors Hours Fees");
        Rec."Labor Hours Fees" := SalesSetup."Labors Hours Fees";
    end;

    local procedure UpdateTravelFees()
    begin
        SalesSetup.Get();
        SalesSetup.TestField("Travel Hours Fees");
        Rec."Travel Hours Fees" := SalesSetup."Travel Hours Fees";
    end;

    local procedure Calculate_Taxes()
    begin
        SalesSetup.Get();
        if SalesSetup."Tariff %" <= 0 then
            exit;
        Rec."Amount Taxes" := Round(Rec.GetTotals() * SalesSetup."Warr & Serv. Taxes" / 100, 0.01);
    end;

    procedure InsertWarrantyServices(var SalesHeader: Record "Sales Header")
    var
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        LastSalesline: Integer;
    begin
        SalesSetup.Get();
        SalesSetup.TestField("G/L Account Shipment");
        SalesSetup.TestField("G/L Account Labor/Travel");
        SalesSetup.TestField("G/L Account Rush Fee");

        SalesHeader.Validate("Sell-to Customer No.", Rec."LGX ZMO Sell-To Customer No.");

        // miramos temas de la cabecera        
        // añadir la direccion de envío , y datos de llegada
        UpdateSalesHdrShipment(SalesHeader);

        SalesHeader."External Document No." := Rec."LGX ZMO Incident No.";
        SalesHeader."Service & Warranty No." := Rec."LGX ZMO Incident No.";
        SalesHeader.Modify();

        // Creamos las nuevas lineas desde el Warranty & Services
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindLast() then
            LastSalesline := SalesLine."Line No.";

        AddWarrantyServicesLines(SalesHeader, LastSalesline);
        // Shipment 
        AddWarrantyServicesFees(SalesHeader, LastSalesline, format(Rec."Shipphing Method"), SalesSetup."G/L Account Shipment", 1, Rec."Shipping Amount");
        // labor hours 
        AddWarrantyServicesFees(SalesHeader, LastSalesline, 'Labor Hours', SalesSetup."G/L Account Labor/Travel", "Labor Hours Quantity", Rec."Labor Hours Fees");
        // Travel 
        AddWarrantyServicesFees(SalesHeader, LastSalesline, 'Round trip travel hours', SalesSetup."G/L Account Labor/Travel", "Travel Hours Quantity", Rec."Travel Hours Fees");
        // Credit Card
        AddWarrantyServicesFees(SalesHeader, LastSalesline, 'Credit Card Fee', SalesSetup."G/L Account Rush Fee", 1, Rec."Credit Card Fees");
        // Rush Fee
        AddWarrantyServicesFees(SalesHeader, LastSalesline, 'Rush Fee', SalesSetup."G/L Account Rush Fee", 1, Rec."Rush Fees");

        if Rec."Orders Date-Time" = 0DT then begin
            Rec."Orders Date-Time" := CurrentDateTime();
            Rec.Modify();
        end

    end;

    procedure CreateCustomer(): Boolean
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        NoSeriesLine: Record "No. Series Line";
        CustomerCard: page "Customer Card";
        LastCustomerNo: code[20];
    begin
        SalesSetup.Get();
        NoSeriesLine.SetRange("Series Code", SalesSetup."Customer Nos.");
        if NoSeriesLine.FindLast() then
            LastCustomerNo := NoSeriesLine."Last No. Used";

        Customer.Init();
        Customer.Name := Rec."LGX ZMO Sell-to Customer Name";
        Customer.Insert(true);
        UpdateCustomerServWarranty(Customer);
        Rec."LGX ZMO Sell-To Customer No." := Customer."No.";
        Rec.Modify();
        Commit();

        Customer.SetRange("No.", Customer."No.");
        CustomerCard.SetTableView(Customer);
        CustomerCard.LookupMode(true);
        if not (CustomerCard.RunModal() = Action::LookupOK) Then begin
            Customer.Find();
            Customer.Delete();
            NoSeriesLine.SetRange("Series Code", SalesSetup."Customer Nos.");
            if NoSeriesLine.FindLast() then begin
                NoSeriesLine."Last No. Used" := LastCustomerNo;
                NoSeriesLine.Modify();
            end;
            exit;
        end;
        exit(true);
    end;

    local procedure UpdateCustomerServWarranty(var Customer: Record Customer)
    var
        myInt: Integer;
    begin
        Customer.Name := Rec."LGX ZMO Sell-to Customer Name";
        Customer."Name 2" := Rec."LGX ZMO Sell-to Cust. Name 2";
        Customer.Address := Rec."LGX ZMO Sell-to Address";
        Customer."Address 2" := Rec."LGX ZMO Sell-to Address 2";
        Customer.City := Rec."LGX ZMO Sell-to City";
        Customer."Post Code" := Rec."LGX ZMO Sell-to Post Code";
        Customer.County := Rec."LGX ZMO Sell-to County";
        Customer."Country/Region Code" := Rec."LGX ZMO Sell-to C./R. Code";
        Customer.Contact := Rec."LGX ZMO Sell-to Contact";
        Customer."E-Mail" := Rec."LGX ZMO Sell-to E-Mail";
        Customer."Phone No." := Rec."LGX ZMO Sell-to Phone No.";
        Customer."Fax No." := Rec."LGX ZMO Sell-to Fax No.";
        Customer."Tax Liable" := Rec.Taxes;
        Customer.Modify();
    end;

    local procedure UpdateSalesHdrShipment(var SalesHeader: Record "Sales Header")
    begin
        if Rec."LGX ZMO Ship-to Code" <> '' then
            Rec.Validate("LGX ZMO Ship-to Code", Rec."LGX ZMO Ship-to Code");
        if Rec."LGX ZMO Ship-to Name" <> '' then
            Rec.Validate("LGX ZMO Ship-to Name", Rec."LGX ZMO Ship-to Name");
        if Rec."LGX ZMO Ship-to Name 2" <> '' then
            Rec.Validate("LGX ZMO Ship-to Name 2", Rec."LGX ZMO Ship-to Name 2");
        if Rec."LGX ZMO Ship-to Address" <> '' then
            Rec.Validate("LGX ZMO Ship-to Address", Rec."LGX ZMO Ship-to Address");
        if Rec."LGX ZMO Ship-to Address 2" <> '' then
            Rec.Validate("LGX ZMO Ship-to Address 2", Rec."LGX ZMO Ship-to Address 2");
        if Rec."LGX ZMO Ship-to City" <> '' then
            Rec.Validate("LGX ZMO Ship-to City", Rec."LGX ZMO Ship-to City");
        if Rec."LGX ZMO Ship-to County" <> '' then
            Rec.Validate("LGX ZMO Ship-to County", Rec."LGX ZMO Ship-to County");
        if Rec."LGX ZMO Ship-to Post Code" <> '' then
            Rec.Validate("LGX ZMO Ship-to Post Code", Rec."LGX ZMO Ship-to Post Code");
        if Rec."LGX ZMO Ship-to C./R. Code" <> '' then
            Rec.Validate("LGX ZMO Ship-to C./R. Code", Rec."LGX ZMO Ship-to C./R. Code");
        if Rec."LGX ZMO Ship-to E-Mail" <> '' then
            Rec.Validate("LGX ZMO Ship-to E-Mail", Rec."LGX ZMO Ship-to E-Mail");
        if Rec."LGX ZMO Ship-to Phone" <> '' then
            Rec.Validate("LGX ZMO Ship-to Phone", Rec."LGX ZMO Ship-to Phone");
    end;

    procedure AddWarrantyServicesLines(SalesHeader: Record "Sales Header"; var LastSalesline: Integer)
    var
        SalesLine: Record "Sales Line";
        WarrantyServItemsLine: record "ZM Serv & Warr Items";
    begin
        WarrantyServItemsLine.SetRange("LGX ZMO Incident No.", Rec."LGX ZMO Incident No.");
        if WarrantyServItemsLine.FindFirst() then
            repeat
                if not ((WarrantyServItemsLine."Item No." = '') and (WarrantyServItemsLine.Quantity = 0)) then begin
                    LastSalesline += 10000;
                    clear(SalesLine);
                    SalesLine.Init();
                    SalesLine."Document Type" := SalesHeader."Document Type";
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine."Line No." := LastSalesline;
                    SalesLine.Validate(Type, SalesLine.Type::Item);
                    SalesLine.Validate("No.", WarrantyServItemsLine."Item No.");
                    SalesLine.Validate(Quantity, WarrantyServItemsLine.Quantity);
                    SalesLine.Validate("Unit Price", WarrantyServItemsLine."Unit Price");
                    SalesLine.Validate("Line Discount %", Rec.DiscountPorc);
                    SalesLine.Insert(true);
                end else begin
                    if WarrantyServItemsLine.Description <> '' then begin
                        LastSalesline += 10000;
                        clear(SalesLine);
                        SalesLine.Init();
                        SalesLine."Document Type" := SalesHeader."Document Type";
                        SalesLine."Document No." := SalesHeader."No.";
                        SalesLine."Line No." := LastSalesline;
                        SalesLine.Validate(Type, SalesLine.Type::" ");
                        SalesLine.Description := WarrantyServItemsLine.Description;
                        SalesLine.Insert(true);
                    end;
                end;
            until WarrantyServItemsLine.Next() = 0;
    end;

    local procedure CheckCustomerNo(SalesHeader: Record "Sales Header"; Customer: Record Customer): Boolean
    var
        lblConfirm: Label 'The customer for %1 %2 is different from the customer for Warranty & Service %3.\¿Do you want to continue?';
    begin
        if SalesHeader."Sell-to Customer No." = '' then
            exit(true);
        if SalesHeader."Sell-to Customer No." <> Customer."No." then
            if Confirm(lblConfirm, false, SalesHeader."Document Type", SalesHeader."Sell-to Customer Name", Rec."LGX ZMO Sell-to Customer Name") then
                exit(true);
    end;

    local procedure AddWarrantyServicesFees(SalesHeader: Record "Sales Header"; var LastSalesline: Integer; Description: text; AccountNo: code[20]; Quantity: Decimal; amount: Decimal)
    var
        SalesLine: Record "Sales Line";
        WarrantyServItemsLine: record "ZM Serv & Warr Items";
    begin
        if amount <> 0 then begin
            LastSalesline += 10000;
            SalesLine.Init();
            SalesLine."Document Type" := SalesHeader."Document Type";
            SalesLine."Document No." := SalesHeader."No.";
            SalesLine."Line No." := LastSalesline;
            SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
            SalesLine.Validate("No.", AccountNo);
            SalesLine.Validate(Description, Description);
            SalesLine.Validate(Quantity, Quantity);
            SalesLine.Validate("Unit Price", amount);
            SalesLine.Insert(true);
        end;

    end;


    procedure OrdersSendbyEmail()
    var
        Body: Text;
        lblSend: Label 'Warranty & Services %1 Send.';
    begin
        Body := CreateBodyHTMLWarrServ(false);

        SendEmailOperations(body);

        if Rec."Sent Quote Date-Time" = 0DT then begin
            Rec."Sent Quote Date-Time" := CurrentDateTime();
            Rec.Modify();
        end;

        Message(lblSend, Rec."LGX ZMO Incident No.");

    end;

    local procedure SendEmailOperations(body: text)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        UserSetup: Record "User Setup";
        recSMTPSetup: Record "SMTP Mail Setup";
        cduSmtp: Codeunit "SMTP Mail";
        Recipients: text;
        FilePathWarrantyService: text;
        FileName: text;
        lblSubject: Label 'Sales Order Operations Department request Warranty & Services %1';
    begin
        recSMTPSetup.Get();
        recSMTPSetup.TestField("SMTP Server");
        recSMTPSetup.TestField("User ID");
        SalesSetup.Get();
        SalesSetup.TestField("Operations Email");
        Recipients := SalesSetup."Operations Email";
        if UserSetup.Get(UserId) then
            if UserSetup."E-Mail" <> '' then
                Recipients += StrSubstNo(';%1', UserSetup."E-Mail");
        FileName := StrSubstNo('%1 %2.pdf', Rec.TableName, Rec."LGX ZMO Incident No.");
        Clear(cduSmtp);
        cduSmtp.CreateMessage(CompanyName(), recSMTPSetup."User ID", Recipients, StrSubstNo(lblSubject, Rec."LGX ZMO Incident No."), body, TRUE); //pDireccion, pAsunto, pCuerpo, TRUE);

        GetDocAttachmentFile(cduSmtp);
        filePathWarrantyService := GetReportFile();
        if filePathWarrantyService <> '' then
            if Exists(filePathWarrantyService) then
                cduSmtp.AddAttachment(filePathWarrantyService, FileName);

        cduSmtp.Send();

    end;

    procedure ReturnOrdersSendbyEmail()
    var
        Body: Text;
        lblSend: Label 'RMA Warranty & Services %1 Send.';
    begin
        Body := CreateBodyHTMLWarrServ(true);

        SendEmailReturnOrderOperations(body);

        if Rec."Sent Return Order Date-Time" = 0DT then begin
            Rec."Sent Return Order Date-Time" := CurrentDateTime();
            Rec.Modify();
        end;

        Message(lblSend, Rec."LGX ZMO Incident No.");

    end;

    local procedure SendEmailReturnOrderOperations(body: text)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        UserSetup: Record "User Setup";
        recSMTPSetup: Record "SMTP Mail Setup";
        cduSmtp: Codeunit "SMTP Mail";
        Recipients: text;
        FilePathWarrantyService: text;
        FileName: text;
        lblSubject: Label 'Return Order Warranty & Services from Operations Department RMA %1';
    begin
        recSMTPSetup.Get();
        recSMTPSetup.TestField("SMTP Server");
        recSMTPSetup.TestField("User ID");
        SalesSetup.Get();
        SalesSetup.TestField("Operations Email");
        Recipients := SalesSetup."Operations Email";
        if UserSetup.Get(UserId) then
            if UserSetup."E-Mail" <> '' then
                Recipients += StrSubstNo(';%1', UserSetup."E-Mail");
        FileName := StrSubstNo('%1 %2.pdf', Rec.TableName, Rec."LGX ZMO Incident No.");
        Clear(cduSmtp);
        cduSmtp.CreateMessage(CompanyName(), recSMTPSetup."User ID", Recipients, StrSubstNo(lblSubject, Rec."LGX ZMO Incident No."), body, TRUE); //pDireccion, pAsunto, pCuerpo, TRUE);

        GetDocAttachmentFile(cduSmtp);
        filePathWarrantyService := GetReturnReportFile();
        if filePathWarrantyService <> '' then
            if Exists(filePathWarrantyService) then
                cduSmtp.AddAttachment(filePathWarrantyService, FileName);
        cduSmtp.Send();

    end;

    local procedure GetDocAttachmentFile(var cduSmtp: Codeunit "SMTP Mail") Included: Boolean
    var
        DocAttachment: Record "Unlinked Attachment";
        cuFileManagement: Codeunit "File Management";
        FilePathName: text;
        FileName: Text;
        FileExtension: text;
    begin
        DocAttachment.Reset();
        // DocAttachment.SetRange("Table ID", 38);
        DocAttachment.SetRange(TypeDoc, docAttachment.TypeDoc::Customer);
        DocAttachment.SetRange("No.", Rec."LGX ZMO Incident No.");
        if DocAttachment.FindSet() then
            repeat
                DocAttachment.CalcFields(Content);
                FileExtension := cuFileManagement.GetExtension(DocAttachment."File Name");
                FilePathName := cuFileManagement.ServerTempFileName(FileExtension);
                FileName := StrSubstNo('%1 %2', Rec."LGX ZMO Incident No.", docAttachment."File Name", FileExtension);
                DocAttachment.Content.Export(FilePathName);
                cduSmtp.AddAttachment(FilePathName, FileName);
                Included := true;
            until DocAttachment.Next() = 0;
    end;

    local procedure GetReportFile() filePath: Text;
    var
        WarrServHdr: Record "LGX ZMO Service & Warranty Hdr";
        DocAttachment: Record "Document Attachment";
        FileManagement: Codeunit "File Management";
        ZMOWarrantyService: Report "LGX ZMO Warranty & Service";
    begin
        filePath := FileManagement.ServerTempFileName('pdf');
        WarrServHdr.SetRange("LGX ZMO Incident No.", Rec."LGX ZMO Incident No.");
        ZMOWarrantyService.SetTableView(WarrServHdr);
        ZMOWarrantyService.SaveAsPdf(filePath);
    end;

    local procedure GetReturnReportFile() filePath: Text;
    var
        WarrServHdr: Record "LGX ZMO Service & Warranty Hdr";
        DocAttachment: Record "Document Attachment";
        FileManagement: Codeunit "File Management";
        ZMOWarrantyService: Report "LGX ZMO Warranty & Service RMA";
    begin
        filePath := FileManagement.ServerTempFileName('pdf');
        WarrServHdr.SetRange("LGX ZMO Incident No.", Rec."LGX ZMO Incident No.");
        ZMOWarrantyService.SetTableView(WarrServHdr);
        ZMOWarrantyService.SaveAsPdf(filePath);
    end;

    local procedure CreateBodyHTMLWarrServ(SkipShiptp: Boolean) BodyMail: text
    var
        ServWarrItems: Record "ZM Serv & Warr Items";
        lblHdr1: Label '<h3 style="text-align: left; color: #3f7320;"><span style="border-bottom: 4px solid #c82828;">%1 No.:&nbsp;</span>%2</h3>';
        lblHdr2: Label '<p><strong>%1: </strong>%2</p>';
        lblHdrIni: Label '<p>';
        lblHdr3: Label '<strong>%1: </strong>%2<br />';
        lblBlank: Label '<p></p>';
        lblHdrFin: Label '</p>';
        lblTableHdrIni: Label '<table class="header" style="height: 54px;width: 1000px;"><thead><tr style="background-color: #999999;">';
        lblTableHdr: Label '<td><strong><span style="width: %1px;"color: #c82828;text-align: left;">%2</span></strong></td>';
        lblTableHdrFin: Label '</tr></thead>';
        lblTableBodyIni: Label '<tbody><tr>';
        lblTableBodyLeft: Label '<td style="text-align: left;">%2%1%3</td>';
        lblTableBodyright: Label '<td style="text-align: right;">%2%1%3</td>';
        lblTableBodycenter: Label '<td style="text-align: center;">%2%1%3</td>';
        lblTableBodyFin: Label '</tr></tbody>';
        lblTableFin: Label '</table>';
        lblTableComment: Label '<p><strong>%1: </strong>%2</p>';
        Rojo: Label '<span style="color: #ff0000;">';
        RojoFin: Label '</span>';
        color: text;
        Colorfin: text;
    begin
        BodyMail := '';
        BodyMail += StrSubstNo(lblHdr1, Rec.TableName, Rec."LGX ZMO Incident No.");
        BodyMail += lblBlank;
        BodyMail += StrSubstNo(lblHdr1, 'BILL TO', '');
        BodyMail += lblHdrIni;
        BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Sell-to Customer Name"), Rec."LGX ZMO Sell-to Customer Name");
        BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Sell-to Cust. Name 2"), Rec."LGX ZMO Sell-to Cust. Name 2");
        BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Sell-to Address"), Rec."LGX ZMO Sell-to Address");
        BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Sell-to Address 2"), Rec."LGX ZMO Sell-to Address 2");
        BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Sell-to City"), Rec."LGX ZMO Sell-to City");
        BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Sell-to Post Code"), Rec."LGX ZMO Sell-to Post Code");
        BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Sell-to County"), Rec."LGX ZMO Sell-to County");
        BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Sell-to C./R. Code"), Rec."LGX ZMO Sell-to C./R. Code");
        BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Sell-to Contact"), Rec."LGX ZMO Sell-to Contact");
        BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Sell-to Phone No."), Rec."LGX ZMO Sell-to Phone No.");
        BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Sell-to E-Mail"), Rec."LGX ZMO Sell-to E-Mail");
        BodyMail += lblHdrFin;
        BodyMail += lblBlank;
        if not SkipShiptp then begin
            BodyMail += StrSubstNo(lblHdr1, 'SHIP TO', '');
            BodyMail += lblHdrIni;
            BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Ship-to Name"), Rec."LGX ZMO Ship-to Name");
            BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Ship-to Name 2"), Rec."LGX ZMO Ship-to Name 2");
            BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Ship-to Address"), Rec."LGX ZMO Ship-to Address");
            BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Ship-to Address 2"), Rec."LGX ZMO Ship-to Address 2");
            BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Ship-to City"), Rec."LGX ZMO Ship-to City");
            BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Ship-to Post Code"), Rec."LGX ZMO Ship-to Post Code");
            BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Ship-to County"), Rec."LGX ZMO Ship-to County");
            BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Ship-to C./R. Code"), Rec."LGX ZMO Ship-to C./R. Code");
            BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Ship-to Contact"), Rec."LGX ZMO Ship-to Contact");
            BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Ship-to Phone"), Rec."LGX ZMO Ship-to Phone");
            BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("LGX ZMO Ship-to E-Mail"), Rec."LGX ZMO Ship-to E-Mail");
            BodyMail += lblHdrFin;
            BodyMail += lblBlank;
        end;
        BodyMail += StrSubstNo(lblHdr3, Rec."Cotization Date");
        BodyMail += lblBlank;
        BodyMail += lblTableHdrIni;
        BodyMail += StrSubstNo(lblTableHdr, 200, ServWarrItems.FieldCaption("Item No."));
        BodyMail += StrSubstNo(lblTableHdr, 500, ServWarrItems.FieldCaption(Description));
        BodyMail += StrSubstNo(lblTableHdr, 75, ServWarrItems.FieldCaption(Quantity));
        BodyMail += StrSubstNo(lblTableHdr, 75, ServWarrItems.FieldCaption("Unit Price"));
        BodyMail += StrSubstNo(lblTableHdr, 75, 'Amount');
        BodyMail += lblTableHdrFin;

        ServWarrItems.Reset();
        ServWarrItems.SetRange("LGX ZMO Incident No.", Rec."LGX ZMO Incident No.");
        if ServWarrItems.FindFirst() then
            repeat
                //         color := '';
                //         Colorfin := '';
                //         ServiceLine.Reset();
                //         ServiceLine.SetRange("Document Type", ServiceLine."Document Type"::Order);
                //         ServiceLine.SetRange("Document No.", SalesLine.PedidoServicio_sga_btc);
                //         ServiceLine.SetRange("Line No.", SalesLine.LinPedidoServicio_sga_btc);
                //         if ServiceLine.FindSet() then begin
                //             if SalesLine."Unit Price" <> ServiceLine."Unit Price" then begin
                //                 color := Rojo;
                //                 Colorfin := RojoFin;
                //             end;
                //         end;
                BodyMail += lblTableBodyIni;
                BodyMail += StrSubstNo(lblTableBodyLeft, ServWarrItems."Item No.", color, Colorfin);
                BodyMail += StrSubstNo(lblTableBodyleft, ServWarrItems.Description, color, Colorfin);
                BodyMail += StrSubstNo(lblTableBodyright, ServWarrItems.Quantity, color, Colorfin);
                BodyMail += StrSubstNo(lblTableBodyright, ServWarrItems."Unit Price", color, Colorfin);
                BodyMail += StrSubstNo(lblTableBodyright, ServWarrItems.Quantity * ServWarrItems."Unit Price", color, Colorfin);
                BodyMail += lblTableBodyFin;
            Until ServWarrItems.next() = 0;
        BodyMail += lblTableFin;
        BodyMail += lblHdrIni;
        //BodyMail += StrSubstNo(lblTableComment, 'comentario:', GetExtensionFieldValuetext(SalesHeader.RecordId, 50103, false));
        BodyMail += StrSubstNo(lblHdr3, Rec."Shipphing Method", Rec."Shipping Amount");
        BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("Labor Hours Fees"), Rec."Labor Hours Fees" * Rec."Labor Hours Quantity");
        BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("Travel Hours Fees"), Rec."Travel Hours Quantity" * Rec."Travel Hours Fees");
        BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("Credit Card Fees"), Rec."Credit Card Fees");
        BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption("Rush Fees"), Rec."Rush Fees");
        BodyMail += StrSubstNo(lblHdr3, Rec.FieldCaption(DiscountPorc), Rec.DiscountPorc);
        BodyMail += lblHdrFin;
        // BodyMail += StrSubstNo(lblHdr2, Rec.FieldCaption(DiscountPorc), Rec.DiscountPorc);
        BodyMail += lblBlank;

    end;

    procedure CalculateSalerOrdersWS(var SalesOrdersWS: Integer; var SalesOrdersPVP: Decimal; var SalesOrdersCost: Decimal)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesOrdersWS := 0;
        SalesOrdersPVP := 0;
        SalesOrdersCost := 0;
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("External Document No.", '%1', '*' + Rec."LGX ZMO Incident No." + '*');
        if SalesHeader.FindSet() then
            repeat
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.CalcSums("Line Amount");
                SalesOrdersWS += SalesLine.Count;
                SalesOrdersPVP := SalesLine."Line Amount";
                if SalesLine.FindSet() then
                    repeat
                        SalesOrdersCost := SalesLine."Unit Cost" * SalesLine.Quantity;
                    until SalesLine.Next() = 0;
            until SalesHeader.Next() = 0;
    end;

    procedure CalculatePurchrOrdersWS(var PurchOrdersWS: Integer; var PurchOrdersPVP: Decimal; var PurchOrdersCost: Decimal)
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
    begin
        PurchOrdersWS := 0;
        PurchOrdersPVP := 0;
        PurchOrdersCost := 0;
        PurchInvHeader.Reset();
        PurchInvHeader.SetFilter("LGX ZMO Service & Warranty No.", '%1', '*' + Rec."LGX ZMO Incident No." + '*');
        if PurchInvHeader.FindSet() then
            repeat
                PurchInvLine.SetRange("Document No.", PurchInvHeader."No.");
                // PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
                PurchInvLine.CalcSums("Line Amount");
                PurchOrdersWS += PurchInvLine.Count;
                PurchOrdersPVP := PurchInvLine."Line Amount";
                if PurchInvLine.FindSet() then
                    repeat
                        PurchOrdersCost := PurchInvLine."Unit Cost" * PurchInvLine.Quantity;
                    until PurchInvLine.Next() = 0;
            until PurchInvHeader.Next() = 0;
    end;

    procedure CopyAddresstoShipto()
    var
        lblConfirm: Label '¿Do you want to copy the address to the shipping address?';
    begin
        if not Confirm(lblConfirm) then
            exit;
        Rec."LGX ZMO Ship-to Name" := Rec."LGX ZMO Sell-to Customer Name";
        Rec."LGX ZMO Ship-to Name 2" := Rec."LGX ZMO Sell-to Cust. Name 2";
        Rec."LGX ZMO Ship-to Address" := Rec."LGX ZMO Sell-to Address";
        Rec."LGX ZMO Ship-to Address 2" := Rec."LGX ZMO Sell-to Address 2";
        Rec."LGX ZMO Ship-to Post Code" := Rec."LGX ZMO Sell-to Post Code";
        Rec."LGX ZMO Ship-to City" := Rec."LGX ZMO Sell-to City";
        Rec."LGX ZMO Ship-to County" := Rec."LGX ZMO Sell-to County";
        Rec."LGX ZMO Ship-to C./R. Code" := Rec."LGX ZMO Sell-to C./R. Code";
        Rec."LGX ZMO Ship-to Contact" := Rec."LGX ZMO Sell-to Contact";
        Rec."LGX ZMO Ship-to Phone" := Rec."LGX ZMO Sell-to Phone No.";
        Rec."LGX ZMO Ship-to E-Mail" := Rec."LGX ZMO Sell-to E-Mail";

    end;

}
