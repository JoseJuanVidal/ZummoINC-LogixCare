report 50019 "LGX ZMO Item Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/LGXZMOItemRegister.Report.rdl';
    Caption = 'ZUMMO Item Register';

    dataset
    {
        dataitem("Item Register"; "Item Register")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Source Code";
            column(FORMAT_TODAY_0_4_; Format(Today(), 0, 4))
            {
            }
            column(TIME; TIME)
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
            column(Item_Register__TABLECAPTION__________ItemRegFilter; "Item Register".TableCaption() + ': ' + ItemRegFilter)
            {
            }
            column(ItemRegFilter; ItemRegFilter)
            {
            }
            column(Item_Ledger_Entry__TABLECAPTION__________ItemEntryFilter; "Item Ledger Entry".TableCaption() + ': ' + ItemEntryFilter)
            {
            }
            column(ItemEntryFilter; ItemEntryFilter)
            {
            }
            column(STRSUBSTNO_Text000__No___; StrSubstNo(Text000, "No."))
            {
            }
            column(SourceCodeText; SourceCodeText)
            {
            }
            column(SourceCode_Description; SourceCode.Description)
            {
            }
            column(Item_Register_No_; "No.")
            {
            }
            column(Item_RegisterCaption; Item_RegisterCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Posting_Date_Caption; "Item Ledger Entry".FIELDCAPTION("Posting Date"))
            {
            }
            column(Item_Ledger_Entry__Entry_Type_Caption; Item_Ledger_Entry__Entry_Type_CaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Item_No__Caption; "Item Ledger Entry".FIELDCAPTION("Item No."))
            {
            }
            column(Item_Ledger_Entry__Invoiced_Quantity_Caption; "Item Ledger Entry".FIELDCAPTION("Invoiced Quantity"))
            {
            }
            column(LineUnitAmountCaption; LineUnitAmountCaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Cost_Amount__Actual__Caption; "Item Ledger Entry".FIELDCAPTION("Cost Amount (Actual)"))
            {
            }
            column(Item_Ledger_Entry__Entry_No__Caption; "Item Ledger Entry".FIELDCAPTION("Entry No."))
            {
            }
            column(Item_Ledger_Entry__Document_No__Caption; "Item Ledger Entry".FIELDCAPTION("Document No."))
            {
            }
            column(Item_Ledger_Entry__Source_Type_Caption; "Item Ledger Entry".FIELDCAPTION("Source Type"))
            {
            }
            column(Item_Ledger_Entry__Source_No__Caption; "Item Ledger Entry".FIELDCAPTION("Source No."))
            {
            }
            column(Item_Ledger_Entry__Applies_to_Entry_Caption; "Item Ledger Entry".FIELDCAPTION("Applies-to Entry"))
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");
                RequestFilterFields = "Item No.", "Entry Type", "Location Code", "Posting Date";
                column(Item_Ledger_Entry__Posting_Date_; "Posting Date")
                {
                }
                column(Item_Ledger_Entry__Entry_Type_; "Entry Type")
                {
                }
                column(Item_Ledger_Entry__Item_No__; "Item No.")
                {
                }
                column(Item_Ledger_Entry__Invoiced_Quantity_; "Invoiced Quantity")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(LineUnitAmount; LineUnitAmount)
                {
                    DecimalPlaces = 2 : 5;
                }
                column(Item_Ledger_Entry__Cost_Amount__Actual__; "Cost Amount (Actual)")
                {
                }
                column(Item_Ledger_Entry__Entry_No__; "Entry No.")
                {
                }
                column(Item_Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(Item_Ledger_Entry__Source_Type_; "Source Type")
                {
                }
                column(Item_Ledger_Entry__Source_No__; "Source No.")
                {
                }
                column(Item_Ledger_Entry__Applies_to_Entry_; "Applies-to Entry")
                {
                }
                column(ItemDescription; ItemDescription)
                {
                }
                column(PrintItemDescriptions; PrintItemDescriptions)
                {
                }
                column(Item_Register___No__; "Item Register"."No.")
                {
                }
                column(Item_Register___To_Entry_No______Item_Register___From_Entry_No_____1; "Item Register"."To Entry No." - "Item Register"."From Entry No." + 1)
                {
                }
                column(Number_of_Entries_in_Register_No_Caption; Number_of_Entries_in_Register_No_CaptionLbl)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    ItemDescription := Description;
                    if ItemDescription = '' then begin
                        if not Item.GET("Item No.") then
                            Item.Init();
                        ItemDescription := Item.Description;
                    end;

                    CalcFields("Cost Amount (Actual)");
                    if "Invoiced Quantity" = 0 then
                        LineUnitAmount := 0
                    else
                        LineUnitAmount := "Cost Amount (Actual)" / "Invoiced Quantity";
                end;

                trigger OnPreDataItem();
                begin
                    SetRange("Entry No.", "Item Register"."From Entry No.", "Item Register"."To Entry No.");
                end;
            }

            trigger OnAfterGetRecord();
            begin
                if "Source Code" = '' then begin
                    SourceCodeText := '';
                    SourceCode.Init();
                end else begin
                    SourceCodeText := FIELDCAPTION("Source Code") + ': ' + "Source Code";
                    if not SourceCode.GET("Source Code") then
                        SourceCode.Init();
                end;
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
                    Caption = 'Options',


                                ;
                    field(PrintItemDescriptions; PrintItemDescriptions)
                    {
                        Caption = 'Print Item Descriptions',


                                    ;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        CompanyInformation.Get();
        ItemRegFilter := "Item Register".GetFilters();
        ItemEntryFilter := "Item Ledger Entry".GetFilters();
    end;

    var
        CompanyInformation: Record "Company Information";
        SourceCode: Record "Source Code";
        Item: Record Item;
        PrintItemDescriptions: Boolean;
        ItemRegFilter: Text;
        ItemEntryFilter: Text;
        ItemDescription: Text[50];
        SourceCodeText: Text[30];
        Text000: Label 'Register No: %1';
        LineUnitAmount: Decimal;
        Item_RegisterCaptionLbl: Label 'Item Register';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Item_Ledger_Entry__Entry_Type_CaptionLbl: Label 'Entry Type';
        LineUnitAmountCaptionLbl: Label 'Unit Amount';
        Number_of_Entries_in_Register_No_CaptionLbl: Label 'Number of Entries in Register No.';
}

