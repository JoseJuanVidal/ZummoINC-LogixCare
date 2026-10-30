report 50008 "LGX ZMO Inventory Movement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep50008.LGXZMOInventoryMovement.rdlc';
    Caption = 'Zummo Inventory Movement';

    dataset
    {
        dataitem("Item Journal Batch"; "Item Journal Batch")
        {
            DataItemTableView = sorting("Journal Template Name", Name);
            RequestFilterFields = "Journal Template Name", Name;
            column(JournalTempName_ItemJournalBatch; "Journal Template Name")
            {
            }
            column(Name_ItemJournalBatch; Name)
            {
            }
            column(InventoryMovementCaption; InventoryMovementCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(JournalTempNameFieldCaption; "Item Journal Line".FIELDCAPTION("Journal Template Name"))
            {
            }
            column(JournalBatchNameFieldCaption; "Item Journal Line".FIELDCAPTION("Journal Batch Name"))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DISPLAYNAME)
            {
            }
            column(TodayFormatted; Format(Today(), 0, 4))
            {
            }
            column(Time; TIME)
            {
            }
            dataitem("Item Journal Line"; "Item Journal Line")
            {
                DataItemLink = "Journal Template Name" = FIELD("Journal Template Name"), "Journal Batch Name" = FIELD(Name);
                RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Location Code", "Bin Code", "Item No.", "Variant Code";
                column(JournalTempName_ItemJournalLine; "Journal Template Name")
                {
                }
                column(JournalBatchName_ItemJournalLine; "Journal Batch Name")
                {
                }
                column(ActivityType; ActivityType)
                {
                    OptionCaption = ' ,Put-away,Pick,Movement';
                }
                column(ItemJnlLineActTypeShowOutput; ActivityType <> ActivityType::" ")
                {
                }
                column(ItemJournalLineTableCaption; TableCaption() + ': ' + ItemJnlLineFilter)
                {
                }
                column(ItemJnlLineFilter; ItemJnlLineFilter)
                {
                }
                column(ItemJnlLineHeader1ShowOutput; ItemJnlTemplate.Type in [ItemJnlTemplate.Type::Item, ItemJnlTemplate.Type::Consumption, ItemJnlTemplate.Type::Output, ItemJnlTemplate.Type::"Prod. Order"])
                {
                }
                column(ItemJnlLineHeader2ShowOutput; ItemJnlTemplate.Type = ItemJnlTemplate.Type::Transfer)
                {
                }
                column(UOM_ItemJournalLine; "Unit of Measure Code")
                {
                }
                column(Qty_ItemJournalLine; Quantity)
                {
                }
                column(BinCode_ItemJournalLine; "Bin Code")
                {
                }
                column(LocationCode_ItemJournalLine; "Location Code")
                {
                }
                column(VariantCode_ItemJournalLine; "Variant Code")
                {
                }
                column(Description_ItemJournalLine; Description)
                {
                }
                column(ItemNo_ItemJournalLine; "Item No.")
                {
                }
                column(PostingDate_ItemJournalLine; Format("Posting Date"))
                {
                }
                column(EntryType_ItemJournalLine; "Entry Type")
                {
                }
                column(QuantityBase_ItemJournalLine; "Quantity (Base)")
                {
                }
                column(QuantityFormat; Quantity)
                {
                }
                column(NewBinCode_ItemJournalLine; "New Bin Code")
                {
                }
                column(NewLocationCode_ItemJournalLine; "New Location Code")
                {
                }
                column(QuantityBaseFormat; "Quantity (Base)")
                {
                }
                column(ActivityTypeCaption; ActivityTypeCaptionLbl)
                {
                }
                column(UOMFieldCaption; FIELDCAPTION("Unit of Measure Code"))
                {
                }
                column(QtyFieldCaption; FIELDCAPTION(Quantity))
                {
                }
                column(BinCodeFieldCaption; FIELDCAPTION("Bin Code"))
                {
                }
                column(LocationCodeFieldCaption; FIELDCAPTION("Location Code"))
                {
                }
                column(VariantCodeFieldCaption; FIELDCAPTION("Variant Code"))
                {
                }
                column(DescriptionFieldCaption; FIELDCAPTION(Description))
                {
                }
                column(ItemNoFieldCaption; FIELDCAPTION("Item No."))
                {
                }
                column(PostingDateCaption; PostingDateCaptionLbl)
                {
                }
                column(EntryTypeFieldCaption; FIELDCAPTION("Entry Type"))
                {
                }
                column(QuantityBaseFieldCaption; FIELDCAPTION("Quantity (Base)"))
                {
                }
                column(NewBinCodeFieldCaption; FIELDCAPTION("New Bin Code"))
                {
                }
                column(NewLocationCodeFieldCaption; FIELDCAPTION("New Location Code"))
                {
                }

                trigger OnAfterGetRecord();
                begin
                    if ("Entry Type" in ["Entry Type"::"Positive Adjmt.", "Entry Type"::Purchase, "Entry Type"::Output]) and
                       (Quantity > 0) and
                       (ActivityType in [ActivityType::Pick, ActivityType::Movement])
                    then
                        CurrReport.Skip();

                    if ("Entry Type" in ["Entry Type"::"Negative Adjmt.", "Entry Type"::Sale, "Entry Type"::Consumption]) and
                       (Quantity < 0) and
                       (ActivityType in [ActivityType::Pick, ActivityType::Movement])
                    then
                        CurrReport.Skip();

                    if ("Entry Type" in ["Entry Type"::"Positive Adjmt.", "Entry Type"::Purchase, "Entry Type"::Output]) and
                       (Quantity < 0) and
                       (ActivityType in [ActivityType::"Put-away", ActivityType::Movement])
                    then
                        CurrReport.Skip();

                    if ("Entry Type" in ["Entry Type"::"Negative Adjmt.", "Entry Type"::Sale, "Entry Type"::Consumption]) and
                       (Quantity > 0) and
                       (ActivityType in [ActivityType::"Put-away", ActivityType::Movement])
                    then
                        CurrReport.Skip();

                    if ("Entry Type" <> "Entry Type"::Transfer) and
                       (ActivityType = ActivityType::Movement)
                    then
                        CurrReport.Skip();
                end;

                trigger OnPreDataItem();
                begin
                    ItemJnlTemplate.GET("Item Journal Batch"."Journal Template Name");
                end;
            }
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
                    field(ActivityType; ActivityType)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Activity Type';
                        OptionCaption = ' ,Put-away,Pick,Movement';
                        ToolTip = 'Specifies the inventory movement activity that a warehouse employee will follow to move items.';
                    }
                }
            }
        }
    }

    trigger OnPreReport();
    begin
        ItemJnlLineFilter := "Item Journal Line".GetFilters();
    end;

    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlLineFilter: Text;
        ActivityType: Option " ","Put-away",Pick,Movement;
        InventoryMovementCaptionLbl: Label 'Inventory Movement';
        PageCaptionLbl: Label 'Page';
        ActivityTypeCaptionLbl: Label 'Activity Type';
        PostingDateCaptionLbl: Label 'Posting Date';

    [Scope('Personalization')]
    procedure InitializeRequest(NewActivityType: Option);
    begin
        ActivityType := NewActivityType;
    end;
}

