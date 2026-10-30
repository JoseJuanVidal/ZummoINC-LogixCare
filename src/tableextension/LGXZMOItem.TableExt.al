tableextension 50002 "LGX ZMO Item" extends Item //27
{
    procedure ShowUsableQtyPerLocation(ItemNo: Code[20]; LocationCode: Code[20]): Decimal
    var
        TransferLine: Record "Transfer Line";
        TempItem: Record Item;
        Qty: Decimal;
    begin
        if not TempItem.Get(ItemNo) then
            exit(0);

        TransferLine.Reset();
        TransferLine.SetRange("Item No.", ItemNo);
        TransferLine.SetRange("Transfer-from Code", LocationCode);
        if TransferLine.FindFirst() then;
        TransferLine.CalcSums(Quantity, "Quantity Shipped");

        TempItem.SetRange("Location Filter", LocationCode);
        TempItem.CalcFields(Inventory, "Qty. on Sales Order", "Qty. on Asm. Component");
        Qty := (TempItem.Inventory - (TempItem."Qty. on Sales Order" + TempItem."Qty. on Asm. Component" +
            (TransferLine.Quantity - TransferLine."Quantity Shipped")));
        exit(Qty);
    end;

}