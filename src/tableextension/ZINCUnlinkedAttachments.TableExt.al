Tableextension 50064 "ZINC Unlinked Attachments" extends "Unlinked Attachment"
{
    fields
    {
        field(50000; "No."; code[20])
        {
            Caption = 'No.';
        }
        field(50001; TypeDoc; Option)
        {
            Caption = 'Type Document';
            OptionMembers = " ",Customer;
        }
    }
}