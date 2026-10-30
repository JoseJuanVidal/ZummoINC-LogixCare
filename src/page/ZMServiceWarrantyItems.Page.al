page 50016 "ZM Service & Warranty Items"
{
    PageType = ListPart;
    Caption = 'Service & Warranty Items';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ZM Serv & Warr Items";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            // group(Options)
            // {
            //     Visible = ShowOptions;
            //     field(Warranty; Warranty)
            //     {
            //         trigger OnValidate()
            //         begin
            //             UpdateFault();
            //         end;
            //     }
            //     field("Service Type"; "Service Type")
            //     {
            //         TableRelation = "ZM Service Order Type".Code where(Type = const("Service Order Type"));
            //         trigger OnValidate()
            //         begin
            //             UpdateFault();
            //         end;
            //     }
            //     field(Fault; Fault)
            //     {
            //         TableRelation = "ZM Service Order Type".Code where(Type = const(Fault));
            //         trigger OnValidate()
            //         begin
            //             UpdateFault();
            //         end;
            //     }
            //     field("Localized Fault"; "Localized Fault")
            //     {


            //         trigger OnValidate()
            //         begin
            //             UpdateFault();
            //         end;
            //     }
            // }
            repeater(General)
            {
                field("LGX ZMO Incident No."; "LGX ZMO Incident No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                // field(Inventory; Inventory)
                // {
                //     ApplicationArea = All;
                // }
                // field("Unit Cost"; "Unit Cost")
                // {
                //     ApplicationArea = All;
                //     Visible = false;
                // }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CalculateCost)
            {
                Caption = 'Calculate Cost';
                Image = Cost;


                trigger OnAction()
                var
                    ServWarrItems: Record "ZM Serv & Warr Items";
                    lblConfirm: Label 'Do you want to update the cost prices of the selected lines %1?';
                begin
                    CurrPage.SetSelectionFilter(ServWarrItems);
                    if not Confirm(lblConfirm, false, ServWarrItems.Count) then
                        exit;
                    if ServWarrItems.FindFirst() then
                        repeat
                            ServWarrItems.UpdateUnitCost();
                            ServWarrItems.Modify();
                        until ServWarrItems.Next() = 0;
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        Rec.Warranty := tmpWarranty;
        Rec."Service Type" := tmpServiceType;
        Rec.Fault := tmpFault;
        Rec."Localized Fault" := tmpLocalizedFault;
    end;

    var
        ServWarranty: Record "LGX ZMO Service & Warranty Hdr";
        tmpWarranty: Boolean;
        tmpServiceType: code[20];
        tmpFault: code[20];
        tmpLocalizedFault: code[20];
        ShowOptions: Boolean;

    local procedure UpdateFault()
    var
        myInt: Integer;
    begin
        if not ShowOptions then
            exit;
        tmpWarranty := Rec.Warranty;
        tmpServiceType := Rec."Service Type";
        tmpFault := Rec.Fault;
        tmpLocalizedFault := Rec."Localized Fault";
        ServWarranty.Reset();
        if ServWarranty.Get(Rec."LGX ZMO Incident No.") then begin
            ServWarranty."LGX ZMO Warranty" := Rec.Warranty;
            ServWarranty."Service Type" := Rec."Service Type";
            ServWarranty.Fault := Rec.Fault;
            ServWarranty."Localized Fault" := Rec."Localized Fault";
            ServWarranty.Modify();
        end;
    end;

    procedure UpdateServiceWarranty(ServiceWarrantyHdr: Record "LGX ZMO Service & Warranty Hdr")
    begin
        tmpWarranty := ServiceWarrantyHdr."LGX ZMO Warranty";
        tmpServiceType := ServiceWarrantyHdr."Service Type";
        tmpFault := ServiceWarrantyHdr.Fault;
        tmpLocalizedFault := ServiceWarrantyHdr."Localized Fault";
        ShowOptions := true;
    end;
}