report 50000 "LGX ZMO Pick Instruction"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/LGXZMOPickInstruction.Report.rdl';
    Caption = 'Zummo Pick Instruction';

    dataset
    {
        dataitem(CopyLoop; Integer)
        {
            DataItemTableView = sorting(Number);
            column(Number; Number)
            {
            }
            column(CompanyNameText; CompNameText)
            {
            }
            column(DateText; DateTxt)
            {
            }
            dataitem("Sales Header"; "Sales Header")
            {
                DataItemTableView = sorting("Document Type", "No.")
                                    where("Document Type" = const(Order));
                RequestFilterFields = "No.";
                column(No_SalesHeader; "No.")
                {
                    IncludeCaption = true;
                }
                column(CustomerNo_SalesHeader; "Sell-to Customer No.")
                {
                    IncludeCaption = true;
                }
                column(CustomerName_SalesHeader; "Sell-to Customer Name")
                {
                    IncludeCaption = true;
                }
                column(ShipmentMethodCode; "Shipment Method Code")
                {
                }
                column(ShipToName; "Ship-to Name")
                {
                }
                column(ShipToAddress; "Ship-to Address")
                {
                }
                column(ShipToAddress2; "Ship-to Address 2")
                {
                }
                column(ShipToCity; "Ship-to City")
                {
                }
                column(ShipToState; "Ship-to County")
                {
                }
                column(ShipToPostCode; "Ship-to Post Code")
                {
                }
                column(ExternalDocNo_SalesHeader; "External Document No.")
                {
                    IncludeCaption = true;
                }
                dataitem("sales Line"; "Sales Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"),
                                   "Document No." = FIELD("No.");
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                    column(LineNo_SalesLine; "Line No.")
                    {
                    }
                    column(ItemNo_SalesLine; "No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_SalesLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(VariantCode_SalesLine; "Variant Code")
                    {
                        IncludeCaption = true;
                    }
                    column(LocationCode_SalesLine; "Location Code")
                    {
                        IncludeCaption = true;
                    }
                    column(BinCode_SalesLine; "Bin Code")
                    {
                        IncludeCaption = true;
                    }
                    column(ShipmentDate_SalesLine; Format("Shipment Date"))
                    {
                    }
                    column(Quantity_SalesLine; Quantity)
                    {
                        IncludeCaption = true;
                    }
                    column(UnitOfMeasure_SalesLine; "Unit of Measure")
                    {
                        IncludeCaption = true;
                    }
                    column(QuantityToShip_SalesLine; "Qty. to Ship")
                    {
                        IncludeCaption = true;
                    }
                    column(QuantityShipped_SalesLine; "Quantity Shipped")
                    {
                        IncludeCaption = true;
                    }
                    column(QtyToAsm; QtyToAsm)
                    {
                    }
                    dataitem("Assembly Line"; "Assembly Line")
                    {
                        DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                        column(No_AssemblyLine; "No.")
                        {
                            IncludeCaption = true;
                        }
                        column(Description_AssemblyLine; Description)
                        {
                            IncludeCaption = true;
                        }
                        column(VariantCode_AssemblyLine; "Variant Code")
                        {
                            IncludeCaption = true;
                        }
                        column(Quantity_AssemblyLine; Quantity)
                        {
                            IncludeCaption = true;
                        }
                        column(QuantityPer_AssemblyLine; "Quantity per")
                        {
                            IncludeCaption = true;
                        }
                        column(UnitOfMeasure_AssemblyLine; GetUOM("Unit of Measure Code"))
                        {
                        }
                        column(LocationCode_AssemblyLine; "Location Code")
                        {
                            IncludeCaption = true;
                        }
                        column(BinCode_AssemblyLine; "Bin Code")
                        {
                            IncludeCaption = true;
                        }
                        column(QuantityToConsume_AssemblyLine; "Quantity to Consume")
                        {
                            IncludeCaption = true;
                        }

                        trigger OnPreDataItem();
                        begin
                            if not AsmExists then
                                CurrReport.Break();
                            SetRange("Document Type", AsmHeader."Document Type");
                            SetRange("Document No.", AsmHeader."No.");
                        end;
                    }

                    trigger OnAfterGetRecord();
                    var
                        AssembleToOrderLink: Record "Assemble-to-Order Link";
                    begin
                        AssembleToOrderLink.Reset();
                        AssembleToOrderLink.SetCurrentKey(Type, "Document Type", "Document No.", "Document Line No.");
                        AssembleToOrderLink.SetRange(Type, AssembleToOrderLink.Type::Sale);
                        AssembleToOrderLink.SetRange("Document Type", "Document Type");
                        AssembleToOrderLink.SetRange("Document No.", "Document No.");
                        AssembleToOrderLink.SetRange("Document Line No.", "Line No.");
                        AsmExists := AssembleToOrderLink.Findfirst();
                        QtyToAsm := 0;
                        if AsmExists then
                            if AsmHeader.GET(AssembleToOrderLink."Assembly Document Type", AssembleToOrderLink."Assembly Document No.") then
                                QtyToAsm := AsmHeader."Quantity to Assemble"
                            else
                                AsmExists := FALSE;

                        //LC>> Adjust Qty to Ship by Qty on Hand
                        if (Type = Type::Item) and ("Outstanding Quantity" > 0) then begin
                            "Qty. to Ship" := GetItemQOH("No.", "Location Code");
                            if "Qty. to Ship" >= "Outstanding Quantity" then
                                "Qty. to Ship" := "Outstanding Quantity";
                            if "Qty. to Ship" < 0 then
                                "Qty. to Ship" := 0;
                        end;
                        //LC<<

                    end;
                }
            }

            trigger OnPreDataItem();
            begin
                SetRange(Number, 1, NoOfCopies + 1);
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
                    field("No of Copies"; NoOfCopies)
                    {
                        ApplicationArea = Advanced;
                        Caption = 'No of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';
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
        OrderPickingListCaption = 'Pick Instruction';
        PageCaption = 'Page';
        ItemNoCaption = 'Item  No.';
        OrderNoCaption = 'Order No.';
        CustomerNoCaption = 'Customer No.';
        CustomerNameCaption = 'Customer Name';
        QtyToAssembleCaption = 'Quantity to Assemble';
        QtyAssembledCaption = 'Quantity Assembled';
        ShipmentDateCaption = 'Shipment Date';
        QtyPickedCaption = 'Quantity Picked';
        UOMCaption = 'Unit of Measure';
        QtyConsumedCaption = 'Quantity Consumed';
        CopyCaption = 'Copy';
    }

    trigger OnPreReport();
    begin
        DateTxt := Format(Today());
        CompNameText := CompanyName();
    end;

    var
        AsmHeader: Record "Assembly Header";
        NoOfCopies: Integer;
        DateTxt: Text;
        CompNameText: Text;
        QtyToAsm: Decimal;
        AsmExists: Boolean;

    local procedure GetUOM(UOMCode: Code[10]): Text;
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if UnitOfMeasure.GET(UOMCode) then
            EXIT(UnitOfMeasure.Description);
        EXIT(UOMCode);
    end;

    [Scope('Personalization')]
    procedure InitializeRequest(NewNoOfCopies: Integer);
    begin
        NoOfCopies := NewNoOfCopies;
    end;

    local procedure GetItemQOH(ItemNo: Code[20]; LocCode: Code[20]): Decimal;
    var
        Item2: Record "Item";
    begin
        Item2.GET(ItemNo);
        Item2.SetFilter("Location Filter", LocCode);
        Item2.CalcFields(Inventory);
        EXIT(Item2.Inventory);
    end;
}

