pageextension 50005 "LGX ZMO Item List" extends "Item List" //31
{
    layout
    {
        modify("Standard Cost")
        {
            HideValue = HideCostAndPosting;
        }
        modify("Unit Cost")
        {
            HideValue = HideCostAndPosting;
        }
        modify("Last Direct Cost")
        {
            HideValue = HideCostAndPosting;
        }
        modify("Price/Profit Calculation")
        {
            HideValue = HideCostAndPosting;
        }
        modify("Profit %")
        {
            HideValue = HideCostAndPosting;
        }
        addbefore("Substitutes Exist")
        {
            field(LGXUsableQtyOnHand; ShowUsableQtyPerLocation("No.", 'HQ'))
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Usable Qty. on Hand';
                DecimalPlaces = 0 : 0;
            }
            field(LGXUsableQtyUsed; ShowUsableQtyPerLocation("No.", 'USED'))
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Usable Qty. on Used';
                DecimalPlaces = 0 : 0;
            }
            field(LGXPurchaseQuantity; "Qty. on Purch. Order")
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Purchase Order Qty.';
                DecimalPlaces = 0 : 0;
            }
        }
        // Antes en la extension Designer (pageextension 50100, hecha con el diseñador por ZUMMO\LCADMIN)
        addafter(Control113)
        {
            field("Item Category Code61587"; "Item Category Code")
            {
                ApplicationArea = All;
            }
            field("Gen. Prod. Posting Group68704"; "Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
            }
            field("Inventory Posting Group86862"; "Inventory Posting Group")
            {
                ApplicationArea = All;
            }
        }
        addafter("Vendor No.")
        {
            field("Vendor Item No.46638"; "Vendor Item No.")
            {
                ApplicationArea = All;
            }
            field("Gross Weight"; "Gross Weight")
            {
                ApplicationArea = All;
            }
            field("Sales Unit of Measure70324"; "Sales Unit of Measure")
            {
                ApplicationArea = All;
            }
            field("Unit List Price"; "Unit List Price")
            {
                ApplicationArea = All;
            }
        }
        modify("Search Description")
        {
            Visible = false;
        }
        modify("Default Deferral Template Code")
        {
            Visible = false;
        }
        modify("Routing No.")
        {
            Visible = false;
        }
        modify("Production BOM No.")
        {
            Visible = false;
        }
        modify("Cost is Adjusted")
        {
            Visible = false;
        }
        addafter("Base Unit of Measure")
        {
            field("Purch. Unit of Measure57398"; "Purch. Unit of Measure")
            {
                ApplicationArea = All;
            }
        }
        modify("Base Unit of Measure")
        {
            Visible = false;
        }
        modify("Substitutes Exist")
        {
            Visible = false;
        }
        addafter("Unit Cost")
        {
            field("Standard Cost10381"; "Standard Cost")
            {
                ApplicationArea = All;
            }
            field("Last Direct Cost67917"; "Last Direct Cost")
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId()) then
            HideCostAndPosting := UserSetup."LGX ZMO Hide Item Field Value";
    end;

    var
        HideCostAndPosting: Boolean;
}