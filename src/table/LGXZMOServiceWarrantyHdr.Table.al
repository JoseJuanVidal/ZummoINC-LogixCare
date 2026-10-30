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
        }
        field(16; "LGX ZMO Action Taken"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Action Taken';
            OptionCaption = 'No Action,Repaired,Replaced';
            OptionMembers = "No Action",Repaired,Replaced;
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
    end;

    trigger OnInsert();
    begin
        SalesSetup.Get();
        If "LGX ZMO Incident No." = '' then begin
            TestNoSeries();
            NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."LGX ZMO No. Series", 0D, "LGX ZMO Incident No.", "LGX ZMO No. Series");
        end;

        "LGX ZMO Incident Date" := Today();
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
}
