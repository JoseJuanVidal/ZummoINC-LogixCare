page 50000 "LGX ZMO Sales Lines BackOrders"
{
    Caption = 'Sales Lines - Back Orders';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Sales Line";
    UsageCategory = Lists;
    ApplicationArea = LGXZMOFunctionality;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = LGXZMOFunctionality;
                    ToolTip = 'Specifies the type of document that you are about to create.';
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                    ToolTip = 'Specifies the document number.';
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                    ToolTip = 'Specifies the number of the customer to whom the items in the sales order will be shipped.';
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the line number.';
                    Visible = false;
                }
                field(Type; Type)
                {
                    ApplicationArea = LGXZMOFunctionality;
                    ToolTip = 'Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account. The type that you enter in this field determines what you can select in the No. field.';
                }
                field("No."; "No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                    ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = LGXZMOFunctionality;
                    ToolTip = 'Specifies a description of the entry of the product to be sold. To add a non-transactional text line, fill in the Description field only.';
                }
                field("Package Tracking No."; "Package Tracking No.")
                {
                    ToolTip = 'Specifies the shipping agent''s package number.';
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.';
                    Visible = true;
                }
                field(Reserve; Reserve)
                {
                    ApplicationArea = LGXZMOFunctionality;
                    ToolTip = 'Specifies whether a reservation can be made for items on this line.';
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = LGXZMOFunctionality;
                    ToolTip = 'Specifies how many units are being sold.';
                }
                field("Quantity Shipped"; "Quantity Shipped")
                {
                    ApplicationArea = LGXZMOFunctionality;
                    ToolTip = 'Specifies the quantity of items that remain to be shipped.';
                    Visible = false;
                }
                field("Outstanding Quantity"; "Outstanding Quantity")
                {
                    ApplicationArea = LGXZMOFunctionality;
                    ToolTip = 'Specifies how many units on the order line have not yet been shipped.';
                }
                field("Reserved Qty. (Base)"; "Reserved Qty. (Base)")
                {
                    ApplicationArea = LGXZMOFunctionality;
                    ToolTip = 'Specifies the value in the Reserved Quantity field, expressed in the base unit of measure.';
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = LGXZMOFunctionality;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = LGXZMOFunctionality;
                    BlankZero = true;
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';
                }
                field("Job No."; "Job No.")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the number of the related job. If you fill in this field and the Job Task No. field, then a job ledger entry will be posted together with the sales line.';
                    Visible = false;
                }
                field("Work Type Code"; "Work Type Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies which work type the resource applies to when the sale is related to a job.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Shipment Date"; "Shipment Date")
                {
                    ApplicationArea = LGXZMOFunctionality;
                    ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Show Document")
                {
                    ApplicationArea = LGXZMOFunctionality;
                    Caption = 'Show Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Open the document that the selected line exists on.';

                    trigger OnAction();
                    var
                        PageManagement: Codeunit "Page Management";
                    begin
                        SalesHeader.GET("Document Type", "Document No.");
                        PageManagement.PageRun(SalesHeader);
                    end;
                }
                action("Reservation Entries")
                {
                    AccessByPermission = TableData 27 = R;
                    ApplicationArea = Advanced;
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'View the entries for every reservation that is made, either manually or automatically.';

                    trigger OnAction();
                    begin
                        ShowReservationEntries(TRUE);
                    end;
                }
                action("Item &Tracking Lines")
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+I';
                    ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';

                    trigger OnAction();
                    begin
                        OpenItemTrackingLines();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Clear(ShortcutDimCode);
    end;

    var
        SalesHeader: Record "Sales Header";
        ShortcutDimCode: array[8] of Code[20];
}

