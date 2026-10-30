report 50002 "LGX ZMO Item Sales by Cust"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/LGXZMOItemSalesbyCust.Report.rdl';
    Caption = 'Zummo Item Sales by Customer-Detail';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = LGXZMOFunctionality;

    dataset
    {
        dataitem("Item Category"; "Item Category")
        {
            RequestFilterFields = "Parent Category";

            dataitem(Item; Item)
            {
                DataItemLink = "Item Category Code" = FIELD(Code);
                PrintOnlyIfDetail = true;
                RequestFilterFields = "No.", "Inventory Posting Group", "Vendor No.", "Location Filter", "Variant Filter";
                column(FORMAT_TODAY_0_4_; FORMAT(Today(), 0, 4))
                {
                }
                column(TIME; Time())
                {
                }
                column(CompanyInformation_Name; CompanyInformation.Name)
                {
                }
                column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                }
                column(USERID; UserId())
                {
                }
                column(Item_TABLECAPTION__________ItemFilter; Item.TABLECAPTION + ': ' + ItemFilter)
                {
                }
                column(CurrReport_PAGENO___1__AND__ItemFilter_______; (ItemFilter <> ''))
                {
                }
                column(Item__No__; "No.")
                {
                }
                column(Item_Description; Description)
                {
                }
                column(Item_Date_Filter; "Date Filter")
                {
                }
                column(Item_Location_Filter; "Location Filter")
                {
                }
                column(Item_Variant_Filter; "Variant Filter")
                {
                }
                column(Item_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
                {
                }
                column(Item_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
                {
                }
                column(Serial_Number_Sold_HistoryCaption; ReportCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Item_Ledger_Entry__Source_No__Caption; "Item Ledger Entry".FIELDCAPTION("Source No."))
                {
                }
                column(Customer_NameCaption; Customer_NameCaptionLbl)
                {
                }
                column(Item_Ledger_Entry__Serial_No__Caption; "Item Ledger Entry".FIELDCAPTION("Serial No."))
                {
                }
                column(Item_Ledger_Entry__Posting_Date_Caption; "Item Ledger Entry".FIELDCAPTION("Posting Date"))
                {
                }
                column(Item_Ledger_Entry__Invoiced_Quantity_Caption; "Item Ledger Entry".FIELDCAPTION("Invoiced Quantity"))
                {
                }
                column(Item_Ledger_Entry__Sales_Amount__Actual__Caption; "Item Ledger Entry".FIELDCAPTION("Sales Amount (Actual)"))
                {
                }
                column(Item_Ledger_Entry__Cost_Amount__Actual__Caption; "Item Ledger Entry".FIELDCAPTION("Cost Amount (Actual)"))
                {
                }
                column(Item_Ledger_Entry__Lot_No__Caption; "Item Ledger Entry".FIELDCAPTION("Lot No."))
                {
                }
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Item No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Location Code" = FIELD("Location Filter"), "Variant Code" = FIELD("Variant Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                    DataItemTableView = SORTING("Entry Type", "Item No.", "Variant Code", "Source Type", "Source No.", "Posting Date") WHERE("Entry Type" = CONST(Sale));

                    column(Item_Ledger_Entry__Source_No__; "Source No.")
                    {
                    }
                    column(Customer_Name; Customer.Name)
                    {
                    }
                    column(Item_Ledger_Entry__Posting_Date_; "Posting Date")
                    {
                    }
                    column(Item_Ledger_Entry__Invoiced_Quvantity_; "Invoiced Quantity")
                    {
                    }
                    column(Item_Ledger_Entry__Sales_Amount__Actual__; "Sales Amount (Actual)")
                    {
                    }
                    column(Item_Ledger_Entry__Cost_Amount__Actual__; "Cost Amount (Actual)")
                    {
                    }
                    column(Item_Ledger_Entry__Lot_No__; "Lot No.")
                    {
                    }
                    column(Item_Ledger_Entry__Serial_No__; "Serial No.")
                    {
                    }
                    column(Item_Ledger_Entry_Entry_No_; "Entry No.")
                    {
                    }
                    column(Item_Ledger_Entry_Item_No_; "Item No.")
                    {
                    }
                    column(Item_Ledger_Entry_Location_Code; "Location Code")
                    {
                    }
                    column(Item_Ledger_Entry_Variant_Code; "Variant Code")
                    {
                    }
                    column(Item_Ledger_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                    {
                    }
                    column(Item_Ledger_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
                    {
                    }
                    column(Shipment_No; "Item Ledger Entry"."Document No.")
                    {
                    }
                    column(Item_Ledger_Entry_Ext_Document_No; "Item Ledger Entry"."External Document No.")
                    {
                    }
                    column(Invoice_No; InvoiceNo)
                    {
                    }
                    column(SalesShipmentHeader_Ship_to_Code; SalesShipmentHeader."Ship-to Code")
                    {
                    }
                    column(SalesShipmentHeader_Ship_to_Name; SalesInvHeader."Ship-to Name")
                    {
                    }
                    column(SalesShipmentHeader_Ship_to_Address; SalesInvHeader."Ship-to Address")
                    {
                    }
                    column(SalesShipmentHeader_Ship_to_Address_2; SalesInvHeader."Ship-to Address 2")
                    {
                    }
                    column(SalesShipmentHeader_Ship_to_City; SalesInvHeader."Ship-to City")
                    {
                    }
                    column(SalesShipmentHeader_Ship_to_PostCode; SalesInvHeader."Ship-to Post Code")
                    {
                    }
                    column(SalesShipmentHeader_Ship_to_County; SalesInvHeader."Ship-to County")
                    {
                    }
                    column(SalesShipmentHeader_Ship_to_Country; SalesInvHeader."Ship-to Country/Region Code")
                    {
                    }

                    dataitem(SerialNos; Integer)
                    {
                        trigger OnPreDataItem()
                        begin
                            TempItemLedgEntry.Reset();
                            SerialNos.SetRange(Number, 1, TempItemLedgEntry.Count());
                        end;

                        trigger OnAfterGetRecord()
                        begin
                            if SerialNos.Number = 1 then
                                TempItemLedgEntry.FindFirst()
                            else
                                TempItemLedgEntry.Next();

                            if PrintToExcel then
                                MakeExcelAsmDataBody();
                        end;
                    }

                    trigger OnAfterGetRecord();
                    begin
                        Salesperson.Reset();
                        Salesperson.SetRange("LGX ZMO Salesperson User ID", UserId());
                        Salesperson.SetRange("LGX ZMO Set Cust. List Filter", true);
                        if Salesperson.FindFirst() then begin
                            Customer.Reset();
                            Customer.SetRange("No.", "Source No.");
                            Customer.SetRange("Salesperson Code", Salesperson.Code);
                            if not Customer.FindFirst() then
                                CurrReport.Skip();
                        end;

                        if not Customer.GET("Source No.") then
                            Customer.Init();
                        CALCFIELDS("Cost Amount (Actual)", "Sales Amount (Actual)");

                        "Cost Amount (Actual)" := -"Cost Amount (Actual)";
                        "Invoiced Quantity" := -"Invoiced Quantity";

                        CLEAR(SalesShipmentHeader);
                        if SalesShipmentHeader.GET("Document No.") then;

                        CLEAR(InvoiceNo);
                        ValueEntry.Reset();
                        ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
                        ValueEntry.SetRange("Item Ledger Entry No.", "Entry No.");
                        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
                        ValueEntry.SetFilter("Invoiced Quantity", '<>0');
                        if ValueEntry.FindFirst() then
                            InvoiceNo := ValueEntry."Document No.";

                        CLEAR(SalesInvHeader);
                        if SalesInvHeader.GET(InvoiceNo) then;

                        if IncludeSerialAssemblyComp then
                            CollectAsmInformationNoAssInfo();

                        if (PrintToExcel) then
                            MakeExcelDataBody();
                    end;
                }
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                field(LGXZMOPrintToExcel; PrintToExcel)
                {
                    Caption = 'Print to Excel';
                }
                field(LGXZMOIncludeSerialAssemblyComp; IncludeSerialAssemblyComp)
                {
                    Caption = 'Inc. Serial Nos. from Ass. Components';
                }
            }
        }
    }

    trigger OnPreReport();
    begin
        CompanyInformation.Get();
        ItemFilter := Item.GetFilters();
        ItemLedgEntryFilter := "Item Ledger Entry".GetFilters();

        TempItemLedgEntry.Reset();
        TempItemLedgEntry.DeleteAll();

        if PrintToExcel then
            MakeExcelInfo();
    end;

    trigger OnPostReport();
    begin
        if PrintToExcel then
            CreateExcelbook();
    end;

    local procedure CollectAsmInformationNoAssInfo()
    var
        LocalItem: Record Item;
        ItemLedgEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        TempItemLedgEntry.Reset();
        TempItemLedgEntry.DeleteAll();

        if SalesShipmentLine.GET("Item Ledger Entry"."Document No.", "Item Ledger Entry"."Document Line No.") then
            if SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) then begin
                PostedAsmLine.SetRange("Document No.", PostedAsmHeader."No.");
                if PostedAsmLine.FindSet() then
                    repeat
                        ItemLedgEntry.Reset();
                        ItemLedgEntry.SETCURRENTKEY("Document No.");
                        ItemLedgEntry.SetRange("Document No.", PostedAsmLine."Document No.");
                        ItemLedgEntry.SetRange("Posting Date", PostedAsmHeader."Posting Date");
                        ItemLedgEntry.SetRange("Item No.", PostedAsmLine."No.");
                        if ItemLedgEntry.FindSet() then
                            repeat
                                if ItemLedgEntry."Serial No." <> '' then begin
                                    TempItemLedgEntry := ItemLedgEntry;
                                    TempItemLedgEntry.Quantity := ValueEntry."Invoiced Quantity";

                                    if LocalItem.Get(ItemLedgEntry."Item No.") then
                                        TempItemLedgEntry.Description := LocalItem.Description;

                                    if TempItemLedgEntry.Quantity <> 0 then
                                        TempItemLedgEntry.Insert();
                                end;
                            until ItemLedgEntry.Next() = 0;
                    until PostedAsmLine.Next() = 0;
            end;
    end;

    local procedure MakeExcelInfo();
    begin
        ExcelBuf.SetUseInfoSheet();
        ExcelBuf.AddInfoColumn(Format(CompanyNameLbl), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(CompanyInformation.Name, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(Format(ReportNameLbl), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(Format(ReportCaptionLbl), false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(Format(ReportNoLbl), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(REPORT::"Item Sales by Customer", false, false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(Format(USerIdLbl), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(USERID, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(Format(DateTimeLbl), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(Today(), false, false, false, false, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddInfoColumn(TIME, false, false, false, false, '', ExcelBuf."Cell Type"::Time);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(Format(ItemFilterLbl), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(ItemFilter, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(Format(ItemLedgerEntryFiltersLbl), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(ItemLedgEntryFilter, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.ClearNewRow();
        MakeExcelDataHeader();
    end;

    local procedure MakeExcelDataHeader();
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(Item.TableCaption() + ' ' + Item.FIELDCAPTION("No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item.TableCaption() + ' ' + Item.FIELDCAPTION(Description), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.TableCaption() + ' ' + Customer.FIELDCAPTION("No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.TableCaption() + ' ' + Customer.FIELDCAPTION(Name), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry".FIELDCAPTION("Posting Date"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(InvoiceNoLbl, false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry".FIELDCAPTION("External Document No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry".FIELDCAPTION("Invoiced Quantity"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry".FIELDCAPTION("Sales Amount (Actual)"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry".FIELDCAPTION("Cost Amount (Actual)"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry".FIELDCAPTION("Lot No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry".FIELDCAPTION("Serial No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);

        if IncludeSerialAssemblyComp then begin
            ExcelBuf.AddColumn('Component ' + Item.FIELDCAPTION("No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('Component ' + Item.FIELDCAPTION(Description), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('Component ' + "Item Ledger Entry".FIELDCAPTION("Lot No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('Component ' + "Item Ledger Entry".FIELDCAPTION("Serial No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        end;

        ExcelBuf.AddColumn(SalesShipmentHeader.FIELDCAPTION("Ship-to Name"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader.FIELDCAPTION("Ship-to Address"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader.FIELDCAPTION("Ship-to Address 2"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader.FIELDCAPTION("Ship-to City"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader.FIELDCAPTION("Ship-to Post Code"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader.FIELDCAPTION("Ship-to County"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader.FIELDCAPTION("Ship-to Country/Region Code"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeExcelDataBody()
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(Item."No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item.Description, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer."No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Posting Date", false, '', false, false, false, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(InvoiceNo, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."External Document No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Invoiced Quantity", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Item Ledger Entry"."Sales Amount (Actual)", false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Item Ledger Entry"."Cost Amount (Actual)", false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Item Ledger Entry"."Lot No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Serial No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);

        if IncludeSerialAssemblyComp then begin
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        end;

        ExcelBuf.AddColumn(SalesShipmentHeader."Ship-to Name", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader."Ship-to Address", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader."Ship-to Address 2", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader."Ship-to City", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader."Ship-to Post Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader."Ship-to County", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader."Ship-to Country/Region Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeExcelAsmDataBody()
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(Item."No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item.Description, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer."No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Posting Date", false, '', false, false, false, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(InvoiceNo, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."External Document No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(-TempItemLedgEntry."Invoiced Quantity", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TempItemLedgEntry."Cost Amount (Actual)", false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Item Ledger Entry"."Lot No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Serial No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(TempItemLedgEntry."Item No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(TempItemLedgEntry.Description, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(TempItemLedgEntry."Lot No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(TempItemLedgEntry."Serial No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader."Ship-to Name", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader."Ship-to Address", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader."Ship-to Address 2", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader."Ship-to City", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader."Ship-to Post Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader."Ship-to County", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesShipmentHeader."Ship-to Country/Region Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure CreateExcelbook();
    begin
        ExcelBuf.CreateNewBook(CopyStr(ReportCaptionLbl, 1, 250));
        ExcelBuf.WriteSheet(WorksheetNameLbl, CompanyName(), UserId());
        ExcelBuf.CloseBook();
        ExcelBuf.OpenExcel();
    end;

    var
        CompanyInformation: Record "Company Information";
        Customer: Record Customer;
        SalesShipmentHeader: Record "Sales Shipment Header";
        ValueEntry: Record "Value Entry";
        Salesperson: Record "Salesperson/Purchaser";
        SalesInvHeader: Record "Sales Invoice Header";
        ExcelBuf: Record "Excel Buffer" temporary;
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        PrintToExcel: Boolean;
        IncludeSerialAssemblyComp: Boolean;
        ItemFilter: Text;
        ItemLedgEntryFilter: Text;
        ReportCaptionLbl: Label 'Item Sales by Customer - Detail';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Customer_NameCaptionLbl: Label 'Customer Name';
        InvoiceNo: Code[20];
        WorksheetNameLbl: Label 'Data';
        CompanyNameLbl: Label 'Company Name';
        ReportNoLbl: Label 'Report No.';
        ReportNameLbl: Label 'Report Name';
        USerIdLbl: Label 'User ID';
        DateTimeLbl: Label 'Date / Time';
        ItemFilterLbl: Label 'Item Filters';
        InvoiceNoLbl: Label 'Invoice No.';
        ItemLedgerEntryFiltersLbl: Label 'Item Ledger Entry Filters';
}
