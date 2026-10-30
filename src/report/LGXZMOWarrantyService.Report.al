report 50025 "LGX ZMO Warranty & Service"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/LGXZMOWarrantyService.Report.rdl';
    Caption = 'Zummo Warranty & Service';

    dataset
    {
        dataitem("LGX ZMO Service & Warranty Hdr"; "LGX ZMO Service & Warranty Hdr")
        {
            // PrintOnlyIfDetail = true;
            RequestFilterFields = "LGX ZMO Incident No.", "LGX ZMO Sell-To Customer No.";
            RequestFilterHeading = 'Service & Warranty';

            column(txtHeader; txtHeader) { }
            column(LGX_ZMO_Incident_No_; "LGX ZMO Incident No.") { }
            column(LGX_ZMO_Incident_Date; "LGX ZMO Incident Date") { }
            column(LGX_ZMO_Warranty; Format("LGX ZMO Warranty")) { }
            column(LGX_ZMO_Serial_No_; "LGX ZMO Serial No.") { }
            column(Items_No_; "LGX ZMO Item No.") { }
            column(Item_Description; "LGX ZMO Item Description") { }
            column(LGX_ZMO_Sell_To_Customer_No_; "LGX ZMO Sell-To Customer No.") { }
            column(LGX_ZMO_Sell_to_Customer_Name; "LGX ZMO Sell-to Customer Name") { }
            column(LGX_ZMO_Sell_to_Address; "LGX ZMO Sell-to Address") { }
            column(LGX_ZMO_Sell_to_E_Mail; "LGX ZMO Sell-to E-Mail") { }
            column(LGX_ZMO_Sell_to_Phone_No_; "LGX ZMO Sell-to Phone No.") { }
            column(LGX_ZMO_Sell_to_City; "LGX ZMO Sell-to City") { }
            column(LGX_ZMO_Sell_to_Post_Code; "LGX ZMO Sell-to Post Code") { }
            column(LGX_ZMO_Sell_to_County; "LGX ZMO Sell-to County") { }
            column(LGX_ZMO_Sell_to_C__R__Code; "LGX ZMO Sell-to C./R. Code") { }
            column(LGX_ZMO_Sell_to_Contact; "LGX ZMO Sell-to Contact") { }
            column(LGX_ZMO_Ship_to_Name; "LGX ZMO Ship-to Name") { }
            column(LGX_ZMO_Ship_to_Address; "LGX ZMO Ship-to Address") { }
            column(LGX_ZMO_Ship_to_City; "LGX ZMO Ship-to City") { }
            column(LGX_ZMO_Ship_to_County; "LGX ZMO Ship-to County") { }
            column(LGX_ZMO_Ship_to_Post_Code; "LGX ZMO Ship-to Post Code") { }
            column(LGX_ZMO_Ship_to_C__R__Code; "LGX ZMO Ship-to C./R. Code") { }
            column(LGX_ZMO_Ship_to_E_Mail; "LGX ZMO Ship-to E-Mail") { }
            column(LGX_ZMO_Ship_to_Phone; "LGX ZMO Ship-to Phone") { }
            column(LGX_ZMO_Ship_to_Contact; "LGX ZMO Ship-to Contact") { }
            column(Shipphing_Method; "Shipphing Method") { }
            column(Shipping_Amount; "Shipping Amount") { }
            column(Labor_Hours_Fees; "Labor Hours Fees") { }
            column(Labor_Hours_Quantity; "Labor Hours Quantity") { }
            column(TotalLabors; "Labor Hours Quantity" * "Labor Hours Fees") { }
            column(Travel_Hours_Quantity; "Travel Hours Quantity") { }
            column(Travel_Hours_Fees; "Travel Hours Fees") { }
            column(TotalTravel; "Travel Hours Fees" * "Travel Hours Quantity") { }
            column(Credit_Card_Fees; "Credit Card Fees") { }
            column(Rush_Fees; "Rush Fees") { }
            column(Amount_Taxes; "Amount Taxes") { }
            column(Amount_Discount; "Amount Discount") { }
            column(Amount_subtotal; GetItemsAmount() + GetTotalsCharges()) { }
            column(Amount_total; GetTotals()) { }
            column(Service_Company; "Service Company") { }
            column(lblRushfee; lblRushfee) { }
            column(lblDisclaimer; lblDisclaimer) { }
            column(lblCreditCar; lblCreditCar) { }
            column(lblCreditCarNo; lblCreditCarNo) { }
            column(lblCreditCarAddress; lblCreditCarAddress) { }
            column(lblCreditCarState; lblCreditCarState) { }
            column(lblCreditCarSufix; lblCreditCarSufix) { }
            column(lblCreditCarSignature; lblCreditCarSignature) { }
            column(lblCreditCardDate; lblCreditCardDate) { }

            dataitem("ZM Serv & Warr Items"; "ZM Serv & Warr Items")
            {
                DataItemLink = "LGX ZMO Incident No." = field("LGX ZMO Incident No.");

                column(Line_No_; "Line No.") { }
                column(Item_No_; "Item No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_Price; "Unit Price") { }
                column(Amount; Amount) { }

                trigger OnAfterGetRecord();
                begin
                end;

                trigger OnPostDataItem();
                begin


                end;

                trigger OnPreDataItem();
                begin
                end;
            }

            trigger OnAfterGetRecord();
            begin
                // cambiamos el label del header a
                case "LGX ZMO Service & Warranty Hdr"."LGX ZMO Warranty" of
                    true:
                        txtHeader := lblWarranty;
                    else
                        txtHeader := lblServiceReq;

                end;
            end;
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        CompanyInfo.Get();
    end;

    trigger OnPreReport();
    begin
        FormatAddress.Company(CompanyAddress, CompanyInformation)
    end;

    var
        CompanyInformation: Record "Company Information";
        CompanyInfo: Record "Company Information";
        FormatAddress: Codeunit "Format Address";
        CompanyAddress: array[8] of text[100];
        lblWarranty: Label 'Warranty';
        lblServiceReq: Label 'Service Request Quote';
        txtHeader: text;

        lblRushfee: label 'By checking here I accept to pay $50.00 more if I want to have my order processed after 2:00 PM as a rush fee (Mark with an X)';
        lblDisclaimer: Label 'Disclaimer of agreement: This is a juicer mechanical repair/inspection non-refundable for services, once the tech opens the machine, he/she may find other parts damaged that might need to be replaced and or extra time than quoted. ';
        lblCreditCar: Label 'CREDIT CARD AUTHORIZATION FORM';
        lblCreditCarNo: Label 'Credit Card #:';
        lblCreditCarAddress: Label 'Billing address for credit card:';
        lblCreditCarState: Label 'City/State/ZIP:';
        lblCreditCarSufix: Label 'ALL CREDIT CARDS ACCEPTED';
        lblCreditCarSignature: Label 'Cardholder''s signature';
        lblCreditCardDate: Label 'Date';
}

