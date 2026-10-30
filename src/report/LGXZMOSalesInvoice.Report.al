report 50012 "LGX ZMO Sales Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/LGXZMOSalesInvoice.Report.rdl';
    Caption = 'ZUMMO Sales - Invoice';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";
            RequestFilterHeading = 'Sales Invoice';

            column(No_SalesInvHeader; "No.")
            {
            }
            column(Payments_; Payments)
            {
            }
            column(CreditMemoAmt_; CreditMemoAmt)
            {
            }
            column(RemainingAmt_; RemainingAmt)
            {
            }
            column(ShipAgentNameCaption; ShipAgentNameCaption)
            {
            }
            column(ShippingAgentName; ShippingAgent.Name)
            {
            }
            column(ZummoShipmentNoCaption; ZummoShipmentNoCaption)
            {
            }
            column(ZummoShippmentNo; SalesShipmentHeader."No.")
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                column(TaxAmount; "Amount Including VAT" - Amount)
                {
                }

                dataitem(SalesLineComments; "Sales Comment Line")
                {
                    DataItemLink = "No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                    DataItemTableView = sorting("Document Type", "No.", "Document Line No.", "Line No.") where("Document Type" = const("Posted Invoice"), "Print On Invoice" = const(true));

                    trigger OnAfterGetRecord();
                    begin
                        with TempSalesInvoiceLine do begin
                            Init();
                            "Document No." := "Sales Invoice Header"."No.";
                            "Line No." := HighestLineNo + 10;
                            HighestLineNo := "Line No.";
                        end;
                        if StrLen(Comment) <= MaxStrLen(TempSalesInvoiceLine.Description) then begin
                            TempSalesInvoiceLine.Description := Comment;
                            TempSalesInvoiceLine."Description 2" := '';
                        end else begin
                            SpacePointer := MaxStrLen(TempSalesInvoiceLine.Description) + 1;
                            while (SpacePointer > 1) and (Comment[SpacePointer] <> ' ') do
                                SpacePointer := SpacePointer - 1;
                            if SpacePointer = 1 then
                                SpacePointer := MaxStrLen(TempSalesInvoiceLine.Description) + 1;
                            TempSalesInvoiceLine.Description := CopyStr(Comment, 1, SpacePointer - 1);
                            TempSalesInvoiceLine."Description 2" :=
                              CopyStr(CopyStr(Comment, SpacePointer + 1), 1, MaxStrLen(TempSalesInvoiceLine."Description 2"));
                        end;
                        TempSalesInvoiceLine.Insert();
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    TempSalesInvoiceLine := "Sales Invoice Line";
                    TempSalesInvoiceLine.Insert();
                    TempSalesInvoiceLineAsm := "Sales Invoice Line";
                    TempSalesInvoiceLineAsm.Insert();

                    HighestLineNo := "Line No.";

                    GetSerialLotNoSalesInvLine();
                end;

                trigger OnPreDataItem();
                begin
                    TempSalesInvoiceLine.Reset();
                    TempSalesInvoiceLine.DeleteAll();
                    TempSalesInvoiceLineAsm.Reset();
                    TempSalesInvoiceLineAsm.DeleteAll();
                end;
            }
            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = sorting("Document Type", "No.", "Document Line No.", "Line No.") where("Document Type" = const("Posted Invoice"), "Print On Invoice" = const(true), "Document Line No." = const(0));
                column(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    with TempSalesInvoiceLine do begin
                        Init();
                        "Document No." := "Sales Invoice Header"."No.";
                        "Line No." := HighestLineNo + 1000;
                        HighestLineNo := "Line No.";
                    end;
                    if StrLen(Comment) <= MaxStrLen(TempSalesInvoiceLine.Description) then begin
                        TempSalesInvoiceLine.Description := Comment;
                        TempSalesInvoiceLine."Description 2" := '';
                    end else begin
                        SpacePointer := MaxStrLen(TempSalesInvoiceLine.Description) + 1;
                        while (SpacePointer > 1) and (Comment[SpacePointer] <> ' ') do
                            SpacePointer := SpacePointer - 1;
                        if SpacePointer = 1 then
                            SpacePointer := MaxStrLen(TempSalesInvoiceLine.Description) + 1;
                        TempSalesInvoiceLine.Description := CopyStr(Comment, 1, SpacePointer - 1);
                        TempSalesInvoiceLine."Description 2" :=
                          CopyStr(CopyStr(Comment, SpacePointer + 1), 1, MaxStrLen(TempSalesInvoiceLine."Description 2"));
                    end;
                    TempSalesInvoiceLine.Insert();
                end;

                trigger OnPreDataItem();
                begin
                    with TempSalesInvoiceLine do begin
                        Init();
                        "Document No." := "Sales Invoice Header"."No.";
                        "Line No." := HighestLineNo + 1000;
                        HighestLineNo := "Line No.";
                    end;
                    TempSalesInvoiceLine.Insert();
                end;
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInformationPicture; CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyAddress1; CompanyAddress[1])
                    {
                    }
                    column(CompanyAddress2; CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress3; CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress4; CompanyAddress[4])
                    {
                    }
                    column(CompanyAddress5; CompanyAddress[5])
                    {
                    }
                    column(CompanyAddress6; CompanyAddress[6])
                    {
                    }
                    column(CopyTxt; CopyTxt)
                    {
                    }
                    column(BillToAddress1; BillToAddress[1])
                    {
                    }
                    column(BillToAddress2; BillToAddress[2])
                    {
                    }
                    column(BillToAddress3; BillToAddress[3])
                    {
                    }
                    column(BillToAddress4; BillToAddress[4])
                    {
                    }
                    column(BillToAddress5; BillToAddress[5])
                    {
                    }
                    column(BillToAddress6; BillToAddress[6])
                    {
                    }
                    column(BillToAddress7; BillToAddress[7])
                    {
                    }
                    column(ShipmentMethodDescription; ShipmentMethod.Description)
                    {
                    }
                    column(ShptDate_SalesInvHeader; "Sales Invoice Header"."Shipment Date")
                    {
                    }
                    column(DueDate_SalesInvHeader; "Sales Invoice Header"."Due Date")
                    {
                    }
                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {
                    }
                    column(ShipToAddress1; ShipToAddress[1])
                    {
                    }
                    column(ShipToAddress2; ShipToAddress[2])
                    {
                    }
                    column(ShipToAddress3; ShipToAddress[3])
                    {
                    }
                    column(ShipToAddress4; ShipToAddress[4])
                    {
                    }
                    column(ShipToAddress5; ShipToAddress[5])
                    {
                    }
                    column(ShipToAddress6; ShipToAddress[6])
                    {
                    }
                    column(ShipToAddress7; ShipToAddress[7])
                    {
                    }
                    column(BilltoCustNo_SalesInvHeader; "Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(ExtDocNo_SalesInvHeader; "Sales Invoice Header"."External Document No.")
                    {
                    }
                    column(OrderDate_SalesInvHeader; "Sales Invoice Header"."Order Date")
                    {
                    }
                    column(OrderNo_SalesInvHeader; "Sales Invoice Header"."Order No.")
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(DocumentDate_SalesInvHeader; "Sales Invoice Header"."Document Date")
                    {
                    }
                    column(CompanyAddress7; CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress8; CompanyAddress[8])
                    {
                    }
                    column(BillToAddress8; BillToAddress[8])
                    {
                    }
                    column(ShipToAddress8; ShipToAddress[8])
                    {
                    }
                    column(TaxRegNo; TaxRegNo)
                    {
                    }
                    column(TaxRegLabel; TaxRegLabel)
                    {
                    }
                    column(DocumentText; DocumentText)
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(CustTaxIdentificationType; Format(Cust."Tax Identification Type"))
                    {
                    }
                    column(BillCaption; BillCaptionLbl)
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
                    {
                    }
                    column(ShipViaCaption; ShipViaCaptionLbl)
                    {
                    }
                    column(ShipDateCaption; ShipDateCaptionLbl)
                    {
                    }
                    column(DueDateCaption; DueDateCaptionLbl)
                    {
                    }
                    column(TermsCaption; TermsCaptionLbl)
                    {
                    }
                    column(CustomerIDCaption; CustomerIDCaptionLbl)
                    {
                    }
                    column(PONumberCaption; PONumberCaptionLbl)
                    {
                    }
                    column(PODateCaption; PODateCaptionLbl)
                    {
                    }
                    column(OurOrderNoCaption; OurOrderNoCaptionLbl)
                    {
                    }
                    column(SalesPersonCaption; SalesPersonCaptionLbl)
                    {
                    }
                    column(ShipCaption; ShipCaptionLbl)
                    {
                    }
                    column(InvoiceNumberCaption; InvoiceNumberCaptionLbl)
                    {
                    }
                    column(InvoiceDateCaption; InvoiceDateCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(PackTrackNo; "Sales Invoice Header"."Package Tracking No.")
                    {
                    }
                    column(PackTrackNoCaption; PackTrackNoCaption)
                    {
                    }
                    dataitem(SalesInvLine; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(AmountExclInvDisc; AmountExclInvDisc)
                        {
                        }
                        column(TempSalesInvoiceLineNo; TempSalesInvoiceLine."No.")
                        {
                        }
                        column(TempSalesInvoiceLineUOM; TempSalesInvoiceLine."Unit of Measure")
                        {
                        }
                        column(OrderedQuantity; OrderedQuantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(TempSalesInvoiceLineQty; TempSalesInvoiceLine.Quantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(UnitPriceToPrint; UnitPriceToPrint)
                        {
                            DecimalPlaces = 2 : 5;
                        }
                        column(LowDescriptionToPrint; LowDescriptionToPrint)
                        {
                        }
                        column(HighDescriptionToPrint; HighDescriptionToPrint)
                        {
                        }
                        column(TempSalesInvoiceLineDocNo; TempSalesInvoiceLine."Document No.")
                        {
                        }
                        column(TempSalesInvoiceLineLineNo; TempSalesInvoiceLine."Line No.")
                        {
                        }
                        column(TaxLiable; TaxLiable)
                        {
                        }
                        column(TempSalesInvoiceLineAmtTaxLiable; TempSalesInvoiceLine.Amount - TaxLiable)
                        {
                        }
                        column(TempSalesInvoiceLineAmtAmtExclInvDisc; TempSalesInvoiceLine.Amount - AmountExclInvDisc)
                        {
                        }
                        column(TempSalesInvoiceLineAmtInclVATAmount; TempSalesInvoiceLine."Amount Including VAT" - TempSalesInvoiceLine.Amount)
                        {
                        }
                        column(TempSalesInvoiceLineAmtInclVAT; TempSalesInvoiceLine."Amount Including VAT")
                        {
                        }
                        column(TotalTaxLabel; TotalTaxLabel)
                        {
                        }
                        column(BreakdownTitle; BreakdownTitle)
                        {
                        }
                        column(BreakdownLabel1; BreakdownLabel[1])
                        {
                        }
                        column(BreakdownAmt1; BreakdownAmt[1])
                        {
                        }
                        column(BreakdownAmt2; BreakdownAmt[2])
                        {
                        }
                        column(BreakdownLabel2; BreakdownLabel[2])
                        {
                        }
                        column(BreakdownAmt3; BreakdownAmt[3])
                        {
                        }
                        column(BreakdownLabel3; BreakdownLabel[3])
                        {
                        }
                        column(BreakdownAmt4; BreakdownAmt[4])
                        {
                        }
                        column(BreakdownLabel4; BreakdownLabel[4])
                        {
                        }
                        column(ItemDescriptionCaption; ItemDescriptionCaptionLbl)
                        {
                        }
                        column(UnitCaption; UnitCaptionLbl)
                        {
                        }
                        column(OrderQtyCaption; OrderQtyCaptionLbl)
                        {
                        }
                        column(QuantityCaption; QuantityCaptionLbl)
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(TotalPriceCaption; TotalPriceCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(InvoiceDiscountCaption; InvoiceDiscountCaptionLbl)
                        {
                        }
                        column(TotalCaption; TotalCaption)
                        {
                        }
                        column(AmountSubjecttoSalesTaxCaption; AmountSubjecttoSalesTaxCaption)
                        {
                        }
                        column(AmountExemptfromSalesTaxCaption; AmountExemptfromSalesTaxCaption)
                        {
                        }
                        dataitem(AsmLoop; "Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(TempPostedAsmLineUOMCode; GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {
                            }
                            column(TempPostedAsmLineQuantity; TempPostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(TempPostedAsmLineDesc; BlanksForIndent() + TempPostedAsmLine.Description)
                            {
                            }
                            column(TempPostedAsmLineNo; BlanksForIndent() + TempPostedAsmLine."No.")
                            {
                            }

                            trigger OnAfterGetRecord();
                            begin
                                if Number = 1 then
                                    TempPostedAsmLine.FindSet()
                                else begin
                                    TempPostedAsmLine.Next();
                                    TaxLiable := 0;
                                    AmountExclInvDisc := 0;
                                    TempSalesInvoiceLine.Amount := 0;
                                    TempSalesInvoiceLine."Amount Including VAT" := 0;
                                end;
                            end;

                            trigger OnPreDataItem();
                            begin
                                Clear(TempPostedAsmLine);
                                SetRange(Number, 1, TempPostedAsmLine.Count());
                            end;
                        }

                        trigger OnAfterGetRecord();
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            with TempSalesInvoiceLine do begin
                                if OnLineNumber = 1 then
                                    Find('-')
                                else
                                    Next();

                                OrderedQuantity := 0;
                                if "Sales Invoice Header"."Order No." = '' then
                                    OrderedQuantity := Quantity
                                else
                                    if OrderLine.GET(1, "Sales Invoice Header"."Order No.", "Line No.") then
                                        OrderedQuantity := OrderLine.Quantity
                                    else begin
                                        ShipmentLine.SetRange("Order No.", "Sales Invoice Header"."Order No.");
                                        ShipmentLine.SetRange("Order Line No.", "Line No.");
                                        if ShipmentLine.Find('-') then
                                            repeat
                                                OrderedQuantity := OrderedQuantity + ShipmentLine.Quantity;
                                            until 0 = ShipmentLine.Next();
                                    end;

                                DescriptionToPrint := Description + ' ' + "Description 2";
                                if Type = 0 then begin
                                    "No." := '';
                                    "Unit of Measure" := '';
                                    Amount := 0;
                                    "Amount Including VAT" := 0;
                                    "Inv. Discount Amount" := 0;
                                    Quantity := 0;
                                end else
                                    if Type = Type::"G/L Account" then
                                        "No." := '';

                                HighDescriptionToPrint := DescriptionToPrint;

                                if Amount <> "Amount Including VAT" then
                                    TaxLiable := Amount
                                else
                                    TaxLiable := 0;

                                AmountExclInvDisc := Amount + "Inv. Discount Amount";

                                if Quantity = 0 then
                                    UnitPriceToPrint := 0 // so it won't print
                                else
                                    UnitPriceToPrint := Round(AmountExclInvDisc / Quantity, 0.00001);
                            end;

                            CollectAsmInformation(TempSalesInvoiceLine);
                        end;

                        trigger OnPreDataItem();
                        begin
                            NumberOfLines := TempSalesInvoiceLine.Count();
                            SetRange(Number, 1, NumberOfLines);
                            OnLineNumber := 0;
                        end;
                    }
                    dataitem(LineFee; "Integer")
                    {
                        DataItemTableView = sorting(Number) order(Ascending) where(Number = filter(1 ..));
                        column(LineFeeCaptionLbl; TempLineFeeNoteOnReportHist.ReportText)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            if not DisplayAdditionalFeeNote then
                                CurrReport.Break();

                            if Number = 1 then begin
                                if not TempLineFeeNoteOnReportHist.FindSet() then
                                    CurrReport.Break();
                            end else
                                if TempLineFeeNoteOnReportHist.Next() = 0 then
                                    CurrReport.Break();
                        end;
                    }
                }

                trigger OnAfterGetRecord();
                begin
                    if CopyNo = NoLoops then begin
                        if not CurrReport.Preview() then
                            SalesInvPrinted.Run("Sales Invoice Header");
                        CurrReport.Break();
                    end;
                    CopyNo := CopyNo + 1;
                    if CopyNo = 1 then // Original
                        Clear(CopyTxt)
                    else
                        CopyTxt := Text000;
                end;

                trigger OnPreDataItem();
                begin
                    NoLoops := 1 + ABS(NoCopies) + Customer."Invoice Copies";
                    if NoLoops <= 0 then
                        NoLoops := 1;
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                if PrintCompany then
                    if RespCenter.GET("Responsibility Center") then begin
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                        CompanyInformation."Phone No." := RespCenter."Phone No.";
                        CompanyInformation."Fax No." := RespCenter."Fax No.";
                    end;
                CurrReport.LANGUAGE := 2057;

                if "Salesperson Code" = '' then
                    Clear(SalesPurchPerson)
                else
                    SalesPurchPerson.GET("Salesperson Code");

                if not Customer.GET("Bill-to Customer No.") then begin
                    Clear(Customer);
                    "Bill-to Name" := Text009;
                    "Ship-to Name" := Text009;
                end;
                DocumentText := USText000;
                if "Prepayment Invoice" then
                    DocumentText := USText001;

                FormatAddress.SalesInvBillTo(BillToAddress, "Sales Invoice Header");
                FormatAddress.SalesInvShipTo(ShipToAddress, ShipToAddress, "Sales Invoice Header");

                if "Payment Terms Code" = '' then
                    Clear(PaymentTerms)
                else
                    PaymentTerms.GET("Payment Terms Code");

                if "Shipment Method Code" = '' then
                    Clear(ShipmentMethod)
                else
                    ShipmentMethod.GET("Shipment Method Code");

                if "Currency Code" = '' then begin
                    GLSetup.TESTFIELD("LCY Code");
                    TotalCaption := StrSubstNo(TotalCaptionTxt, GLSetup."LCY Code");
                    AmountExemptfromSalesTaxCaption := StrSubstNo(AmountExemptfromSalesTaxCaptionTxt, GLSetup."LCY Code");
                    AmountSubjecttoSalesTaxCaption := StrSubstNo(AmountSubjecttoSalesTaxCaptionTxt, GLSetup."LCY Code");
                end else begin
                    TotalCaption := StrSubstNo(TotalCaptionTxt, "Currency Code");
                    AmountExemptfromSalesTaxCaption := StrSubstNo(AmountExemptfromSalesTaxCaption, "Currency Code");
                    AmountSubjecttoSalesTaxCaption := StrSubstNo(AmountSubjecttoSalesTaxCaption, "Currency Code");
                end;

                GetLineFeeNoteOnReportHist("No.");

                if LogInteraction then
                    if not CurrReport.Preview() then
                        if "Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '')
                        else
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Customer, "Bill-to Customer No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '');

                Clear(BreakdownTitle);
                Clear(BreakdownLabel);
                Clear(BreakdownAmt);
                TotalTaxLabel := Text008;
                TaxRegNo := '';
                TaxRegLabel := '';
                if "Tax Area Code" <> '' then begin
                    TaxArea.GET("Tax Area Code");
                    case TaxArea."Country/Region" of
                        TaxArea."Country/Region"::US:
                            TotalTaxLabel := Text005;
                        TaxArea."Country/Region"::CA:
                            begin
                                TotalTaxLabel := Text007;
                                TaxRegNo := CompanyInformation."VAT Registration No.";
                                TaxRegLabel := CompanyInformation.FIELDCAPTION("VAT Registration No.");
                            end;
                    end;
                    SalesTaxCalc.StartSalesTaxCalculation();
                    if TaxArea."Use External Tax Engine" then
                        SalesTaxCalc.CallExternalTaxEngineForDoc(DATABASE::"Sales Invoice Header", 0, "No.")
                    else begin
                        SalesTaxCalc.AddSalesInvoiceLines("No.");
                        SalesTaxCalc.EndSalesTaxCalculation("Posting Date");
                    end;
                    SalesTaxCalc.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
                    BrkIdx := 0;
                    PrevPrintOrder := 0;
                    PrevTaxPercent := 0;
                    with TempSalesTaxAmtLine do begin
                        Reset();
                        SetCurrentKey("Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code");
                        if Find('-') then
                            repeat
                                if ("Print Order" = 0) or
                                   ("Print Order" <> PrevPrintOrder) or
                                   ("Tax %" <> PrevTaxPercent)
                                then begin
                                    BrkIdx := BrkIdx + 1;
                                    if BrkIdx > 1 then
                                        if TaxArea."Country/Region" = TaxArea."Country/Region"::CA then
                                            BreakdownTitle := Text006
                                        else
                                            BreakdownTitle := Text003;

                                    if BrkIdx > ARRAYLEN(BreakdownAmt) then begin
                                        BrkIdx := BrkIdx - 1;
                                        BreakdownLabel[BrkIdx] := Text004;
                                    end else
                                        BreakdownLabel[BrkIdx] := StrSubstNo("Print Description", "Tax %");
                                end;
                                BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + "Tax Amount";
                            until Next() = 0;
                    end;
                    if BrkIdx = 1 then begin
                        Clear(BreakdownLabel);
                        Clear(BreakdownAmt);
                    end;
                end;

                if "Sell-to Customer No." = "Bill-to Customer No." then
                    CalcCreditMemoTotal("No.", "Sell-to Customer No.")
                else
                    CalcCreditMemoTotal("No.", "Bill-to Customer No.");

                IF ShippingAgent.Get("Shipping Agent Code") THEN;
                SalesShipmentHeader.Reset();
                SalesShipmentHeader.SetRange("Order No.", "Order No.");
                IF SalesShipmentHeader.FindFirst() THEN;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoCopies; NoCopies)
                    {
                        ApplicationArea = LGXZMOFunctionality;
                        Caption = 'Number of Copies';
                        ToolTip = 'Specifies the number of copies of each document (in addition to the original) that you want to print.';
                    }
                    field(PrintCompanyAddress; PrintCompany)
                    {
                        ApplicationArea = LGXZMOFunctionality;
                        Caption = 'Print Company Address';
                        ToolTip = 'Specifies if your company address is printed at the top of the sheet, because you do not use pre-printed paper. Leave this check box blank to omit your company''s address.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = LGXZMOFunctionality;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want to record the related interactions with the involved contact person in the Interaction Log Entry table.';
                    }
                    field(DisplayAsmInfo; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Show Assembly Components';
                    }
                    field(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
                    {
                        ApplicationArea = LGXZMOFunctionality;
                        Caption = 'Show Additional Fee Note';
                        ToolTip = 'Specifies if you want notes about additional fees to be shown on the document.';
                    }
                }
            }
        }

        trigger OnInit();
        begin
            LogInteractionEnable := true;
            PrintCompany := true;
            DisplayAssemblyInformation := true;
        end;

        trigger OnOpenPage();
        begin
            InitLogInteraction();
            LogInteractionEnable := LogInteraction;
            PrintCompany := true;
        end;
    }

    trigger OnInitReport();
    begin
        GLSetup.Get();
    end;

    trigger OnPreReport();
    begin
        ShipmentLine.SetCurrentKey("Order No.", "Order Line No.");
        if not CurrReport.UseRequestPage() then
            InitLogInteraction();

        CompanyInformation.Get();
        SalesSetup.Get();

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo3.Get();
                    CompanyInfo3.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo1.Get();
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo2.Get();
                    CompanyInfo2.CalcFields(Picture);
                end;
        end;

        if PrintCompany then
            FormatAddress.Company(CompanyAddress, CompanyInformation)
        else
            Clear(CompanyAddress);
    end;

    var
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        OrderLine: Record "Sales Line";
        ShipmentLine: Record "Sales Shipment Line";
        TempSalesInvoiceLine: Record "Sales Invoice Line" temporary;
        TempSalesInvoiceLineAsm: Record "Sales Invoice Line" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
        TaxArea: Record "Tax Area";
        Cust: Record Customer;
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        GLSetup: Record "General Ledger Setup";
        SalesInvPrinted: Codeunit "Sales Inv.-Printed";
        CompanyAddress: array[8] of Text[50];
        BillToAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        TaxLiable: Decimal;
        OrderedQuantity: Decimal;
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        CopyTxt: Text;
        DescriptionToPrint: Text[210];
        HighDescriptionToPrint: Text[210];
        LowDescriptionToPrint: Text[210];
        PrintCompany: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        SpacePointer: Integer;
        FormatAddress: Codeunit "Format Address";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        SegManagement: Codeunit SegManagement;
        LogInteraction: Boolean;
        Text000: Label 'COPY';
        TaxRegNo: Text;
        TaxRegLabel: Text;
        TotalTaxLabel: Text;
        BreakdownTitle: Text;
        BreakdownLabel: array[4] of Text;
        BreakdownAmt: array[4] of Decimal;
        Text003: Label 'Sales Tax Breakdown:';
        Text004: Label 'Other Taxes';
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        Text005: Label 'Total Sales Tax:';
        Text006: Label 'Tax Breakdown:';
        Text007: Label 'Total Tax:';
        Text008: Label 'Tax:';
        Text009: Label 'VOID INVOICE';
        DocumentText: Text[20];
        USText000: Label 'INVOICE';
        USText001: Label 'PREPAYMENT REQUEST';
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        BillCaptionLbl: Label 'Bill';
        ToCaptionLbl: Label 'To:';
        ShipViaCaptionLbl: Label 'Ship Via';
        ShipDateCaptionLbl: Label 'Ship Date';
        DueDateCaptionLbl: Label 'Due Date';
        TermsCaptionLbl: Label 'Terms';
        CustomerIDCaptionLbl: Label 'Customer ID';
        PONumberCaptionLbl: Label 'P.O. Number';
        PODateCaptionLbl: Label 'P.O. Date';
        OurOrderNoCaptionLbl: Label 'Our Order No.';
        SalesPersonCaptionLbl: Label 'SalesPerson';
        ShipCaptionLbl: Label 'Ship';
        InvoiceNumberCaptionLbl: Label 'Invoice Number:';
        InvoiceDateCaptionLbl: Label 'Invoice Date:';
        PageCaptionLbl: Label 'Page:';
        TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type';
        ItemDescriptionCaptionLbl: Label 'Item/Description';
        UnitCaptionLbl: Label 'Unit';
        OrderQtyCaptionLbl: Label 'Order Qty';
        QuantityCaptionLbl: Label 'Quantity';
        UnitPriceCaptionLbl: Label 'Unit Price';
        TotalPriceCaptionLbl: Label 'Total Price';
        SubtotalCaptionLbl: Label 'Subtotal:';
        InvoiceDiscountCaptionLbl: Label 'Invoice Discount:';
        TotalCaptionTxt: Label 'Total %1:';
        AmountSubjecttoSalesTaxCaptionTxt: Label 'Amount Subject to Sales Tax %1';
        AmountExemptfromSalesTaxCaptionTxt: Label 'Amount Exempt from Sales Tax %1';
        TotalCaption: Text;
        AmountSubjecttoSalesTaxCaption: Text;
        AmountExemptfromSalesTaxCaption: Text;
        DisplayAdditionalFeeNote: Boolean;
        PackTrackNoCaption: Label 'Package Tracking No.:';
        CreditMemoAmt: Decimal;
        RemainingAmt: Decimal;
        Payments: Decimal;
        ShippingAgent: Record "Shipping Agent";
        ZummoShipmentNoCaption: Label 'Zummo Shipment No.:';
        ShipAgentNameCaption: Label 'Shipping Agent Name';
        SalesShipmentHeader: Record "Sales Shipment Header";

    [Scope('Personalization')]
    procedure InitLogInteraction();
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;

    [Scope('Personalization')]
    procedure CollectAsmInformation(TempSalesInvoiceLine: Record "Sales Invoice Line" temporary);
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        TempPostedAsmLine.DeleteAll();
        if not DisplayAssemblyInformation then
            exit;

        if not TempSalesInvoiceLineAsm.GET(TempSalesInvoiceLine."Document No.", TempSalesInvoiceLine."Line No.") then
            exit;

        SalesInvoiceLine.GET(TempSalesInvoiceLineAsm."Document No.", TempSalesInvoiceLineAsm."Line No.");
        if SalesInvoiceLine.Type <> SalesInvoiceLine.Type::Item then
            exit;

        with ValueEntry do begin
            SetCurrentKey("Document No.");
            SetRange("Document No.", SalesInvoiceLine."Document No.");
            SetRange("Document Type", "Document Type"::"Sales Invoice");
            SetRange("Document Line No.", SalesInvoiceLine."Line No.");
            SetRange("Applies-to Entry", 0);
            if not FindSet() then
                exit;
        end;

        repeat
            if ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") then
                if ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" then begin
                    SalesShipmentLine.GET(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
                    if SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) then begin
                        PostedAsmLine.SetRange("Document No.", PostedAsmHeader."No.");
                        if PostedAsmLine.FindSet() then
                            repeat
                                TreatAsmLineBuffer(PostedAsmLine);
                                GetSerialLotNoPostedAsmLine(PostedAsmLine, PostedAsmHeader."Posting Date");  //DTP-JR-20181227
                            until PostedAsmLine.Next() = 0;
                    end;
                end;
        until ValueEntry.Next() = 0;
    end;

    [Scope('Personalization')]
    procedure TreatAsmLineBuffer(PostedAsmLine: Record "Posted Assembly Line");
    begin
        Clear(TempPostedAsmLine);
        TempPostedAsmLine.SetRange(Type, PostedAsmLine.Type);
        TempPostedAsmLine.SetRange("No.", PostedAsmLine."No.");
        TempPostedAsmLine.SetRange("Variant Code", PostedAsmLine."Variant Code");
        TempPostedAsmLine.SetRange(Description, PostedAsmLine.Description);
        TempPostedAsmLine.SetRange("Unit of Measure Code", PostedAsmLine."Unit of Measure Code");
        if TempPostedAsmLine.FindFirst() then begin
            TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
            TempPostedAsmLine.Modify();
        end else begin
            Clear(TempPostedAsmLine);
            TempPostedAsmLine := PostedAsmLine;
            TempPostedAsmLine.Insert();
        end;
    end;

    [Scope('Personalization')]
    procedure GetUOMText(UOMCode: Code[10]): Text[10];
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.GET(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;

    [Scope('Personalization')]
    procedure BlanksForIndent(): Text[10];
    begin
        exit(PADSTR('', 2, ' '));
    end;

    local procedure GetLineFeeNoteOnReportHist(SalesInvoiceHeaderNo: Code[20]);
    var
        LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist.";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        LocalCustomer: Record Customer;
    begin
        TempLineFeeNoteOnReportHist.DeleteAll();
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SetRange("Document No.", SalesInvoiceHeaderNo);
        if not CustLedgerEntry.FindFirst() then
            exit;

        if not LocalCustomer.GET(CustLedgerEntry."Customer No.") then
            exit;

        LineFeeNoteOnReportHist.SetRange("Cust. Ledger Entry No", CustLedgerEntry."Entry No.");
        LineFeeNoteOnReportHist.SetRange("Language Code", LocalCustomer."Language Code");
        if LineFeeNoteOnReportHist.FindSet() then
            repeat
                TempLineFeeNoteOnReportHist.Init();
                TempLineFeeNoteOnReportHist.COPY(LineFeeNoteOnReportHist);
                TempLineFeeNoteOnReportHist.Insert();
            until LineFeeNoteOnReportHist.Next() = 0
        else begin
            LineFeeNoteOnReportHist.SetRange("Language Code", 'ENG');
            if LineFeeNoteOnReportHist.FindSet() then
                repeat
                    TempLineFeeNoteOnReportHist.Init();
                    TempLineFeeNoteOnReportHist.COPY(LineFeeNoteOnReportHist);
                    TempLineFeeNoteOnReportHist.Insert();
                until LineFeeNoteOnReportHist.Next() = 0;
        end;
    end;

    local procedure CalcCreditMemoTotal(DocumentNo: Code[20]; CustomerNo: Code[20])
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CustLedgerEntry2: Record "Cust. Ledger Entry";
    begin
        RemainingAmt := 0;
        CreditMemoAmt := 0;
        Payments := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetCurrentKey("Customer No.", "Document No.", "Closed by Entry No.");
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        CustLedgerEntry.SetRange("Document No.", DocumentNo);
        if CustLedgerEntry.FindFirst() then begin
            Payments := CustLedgerEntry."Closed by Amount (LCY)";
            CustLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
            RemainingAmt := CustLedgerEntry."Remaining Amt. (LCY)";
            CustLedgerEntry2.Reset();
            CustLedgerEntry2.SetRange("Closed by Entry No.", CustLedgerEntry."Entry No.");
            if CustLedgerEntry2.FindSet() then
                repeat
                    CreditMemoAmt += CustLedgerEntry2."Closed by Amount (LCY)";
                until CustLedgerEntry2.Next() = 0;
        end;
    end;

    local procedure GetSerialLotNoSalesInvLine();
    var
        ValueEntryRelation: Record "Value Entry Relation";
        ValueEntry: Record "Value Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        Item: Record Item;
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        InvoiceRowID: Text[250];
        SerialLot: Text[100];
    begin
        if TempSalesInvoiceLine.Type <> TempSalesInvoiceLine.Type::Item then
            exit;

        TempItemLedgEntry.Reset();
        TempItemLedgEntry.DeleteAll();
        InvoiceRowID := TempSalesInvoiceLine.RowID1();

        // Read from Sales Shipment
        ValueEntryRelation.Reset();
        ValueEntryRelation.SetCurrentKey("Source RowId");
        ValueEntryRelation.SetRange("Source RowId", InvoiceRowID);
        if ValueEntryRelation.Find('-') then
            repeat
                ValueEntry.Get(ValueEntryRelation."Value Entry No.");
                ItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.");
                TempItemLedgEntry := ItemLedgEntry;
                TempItemLedgEntry.Quantity := ValueEntry."Invoiced Quantity";
                if TempItemLedgEntry."Entry Type" in [TempItemLedgEntry."Entry Type"::Purchase, TempItemLedgEntry."Entry Type"::Sale] then
                    if TempItemLedgEntry.Quantity <> 0 then
                        TempItemLedgEntry.Insert();
            until ValueEntryRelation.Next() = 0;

        // Read from Assembly Line if not Assembly Info Selected
        CollectAsmInformationNoAssInfo(TempSalesInvoiceLine, TempItemLedgEntry);

        if TempItemLedgEntry.FindFirst() then
            repeat
                if TempSalesInvoiceLine."No." <> TempItemLedgEntry."Item No." then begin
                    Item.Get(TempItemLedgEntry."Item No.");
                    SerialLot := CopyStr(StrSubstNo('S/N %3: (%1) %2', Item."No.", Item.Description, TempItemLedgEntry."Serial No."), 1, MaxStrLen(SerialLot));
                end
                else
                    SerialLot := StrSubstNo('S/N %1', TempItemLedgEntry."Serial No.");

                with TempSalesInvoiceLine do begin
                    Init();
                    "Document No." := "Sales Invoice Header"."No.";
                    "Line No." := HighestLineNo + 10;
                    HighestLineNo := "Line No.";
                end;

                if StrLen(SerialLot) + 1 <= MaxStrLen(TempSalesInvoiceLine.Description) then begin
                    TempSalesInvoiceLine.Description := SerialLot;
                    TempSalesInvoiceLine."Description 2" := '';
                end else begin
                    SpacePointer := MaxStrLen(TempSalesInvoiceLine.Description) + 1;
                    while (SpacePointer > 1) and (SerialLot[SpacePointer] <> ' ') do
                        SpacePointer := SpacePointer - 1;
                    if SpacePointer = 1 then
                        SpacePointer := MaxStrLen(TempSalesInvoiceLine.Description) + 1;
                    TempSalesInvoiceLine.Description := CopyStr(SerialLot, 1, SpacePointer - 1);
                    TempSalesInvoiceLine."Description 2" :=
                      CopyStr(CopyStr(SerialLot, SpacePointer + 1), 1, MaxStrLen(TempSalesInvoiceLine."Description 2"));
                end;
                TempSalesInvoiceLine.Insert();
            until TempItemLedgEntry.Next() = 0;
    end;

    local procedure CollectAsmInformationNoAssInfo(TempSalesInvoiceLine: Record "Sales Invoice Line" temporary; var TempItemLedgEntry: Record "Item Ledger Entry" temporary);
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        if DisplayAssemblyInformation then
            exit;

        if TempSalesInvoiceLine.Type <> TempSalesInvoiceLine.Type::Item then
            exit;

        with ValueEntry do begin
            SetCurrentKey("Document No.");
            SetRange("Document No.", TempSalesInvoiceLine."Document No.");
            SetRange("Document Type", "Document Type"::"Sales Invoice");
            SetRange("Document Line No.", TempSalesInvoiceLine."Line No.");
            SetRange("Applies-to Entry", 0);
            if not FindSet() then
                exit;
        end;

        repeat
            if ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") then
                if ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" then begin
                    SalesShipmentLine.GET(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
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
                                            if TempItemLedgEntry.Quantity <> 0 then
                                                TempItemLedgEntry.Insert();
                                        end;
                                    until ItemLedgEntry.Next() = 0;
                            until PostedAsmLine.Next() = 0;
                    end;
                end;
        until ValueEntry.Next() = 0;
    end;

    local procedure GetSerialLotNoPostedAsmLine(PostedAsmLine: Record "Posted Assembly Line"; PostingDate: Date);
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.Reset();
        ItemLedgEntry.SETCURRENTKEY("Document No.");
        ItemLedgEntry.SetRange("Document No.", PostedAsmLine."Document No.");
        ItemLedgEntry.SetRange("Posting Date", PostingDate);
        ItemLedgEntry.SetRange("Item No.", PostedAsmLine."No.");
        if ItemLedgEntry.FindSet() then
            repeat
                if ItemLedgEntry."Serial No." <> '' then begin
                    CLEAR(TempPostedAsmLine);
                    TempPostedAsmLine."Document No." := PostedAsmLine."Document No.";
                    TempPostedAsmLine."Line No." := PostedAsmLine."Line No.";
                    TempPostedAsmLine.Description := 'Serial # ' + ItemLedgEntry."Serial No.";
                    while not TempPostedAsmLine.Insert() do
                        TempPostedAsmLine."Line No." += 1;
                end;
            until ItemLedgEntry.Next() = 0;
    end;
}

