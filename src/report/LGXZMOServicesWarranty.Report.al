report 50003 "LGX ZMO Services & Warranty"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/LGXZMOServicesWarranty.Report.rdl';
    Caption = 'Services & Warranties';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = LGXZMOFunctionality;

    dataset
    {
        dataitem("Service & Warranty Line"; "LGX ZMO Service & Warr. Line")
        {
            DataItemTableView = sorting("LGX ZMO Incident No.", "LGX ZMO Line No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "LGX ZMO Incident No.", "LGX ZMO Service Company No.", "LGX ZMO Reason Code";
            column(ServiceCompanyNo_; ServiceCompanyNo)
            {
            }
            column(ServiceCompanyName_; ServiceCompanyName)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF GETFILTER("LGX ZMO Service Company No.") <> '' then begin
                    ServiceCompanyNo := "LGX ZMO Service Company No.";
                    ServiceCompanyName := "LGX ZMO Service Company Name";
                end;
            end;
        }
        dataitem("Service & Warranty Header"; "LGX ZMO Service & Warranty Hdr")
        {
            RequestFilterFields = "LGX ZMO Serial No.", "LGX ZMO Incident Date", "LGX ZMO Warranty", "LGX ZMO Sell-to Customer Name", "LGX ZMO Status";
            column(IncidentNo_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Incident No.")
            {
            }
            column(SerialNo_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Serial No.")
            {
            }
            column(SalesShipmentNo_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Sales Shipment No.")
            {
            }
            column(PostingDate_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Purchase Date")
            {
            }
            column(IncidentDate_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Incident Date")
            {
            }
            column(Warranty_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Warranty")
            {
            }
            column(Actions_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Action Taken")
            {
            }
            column(NewSerialNo_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO New Serial No.")
            {
            }
            column(SellToCustomerNo_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Sell-To Customer No.")
            {
            }
            column(SelltoCustomerName_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Sell-to Customer Name")
            {
            }
            column(SelltoCustomerName2_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Sell-to Cust. Name 2")
            {
            }
            column(SelltoAddress_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Sell-to Address")
            {
            }
            column(SelltoAddress2_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Sell-to Address 2")
            {
            }
            column(SelltoCity_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Sell-to City")
            {
            }
            column(SelltoPostCode_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Sell-to Post Code")
            {
            }
            column(SelltoCounty_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Sell-to County")
            {
            }
            column(SelltoCountryRegionCode_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Sell-to C./R. Code")
            {
            }
            column(SelltoContact_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Sell-to Contact")
            {
            }
            column(SelltoPhoneNo_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Sell-to Phone No.")
            {
            }
            column(SelltoFaxNo_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Sell-to Fax No.")
            {
            }
            column(SelltoEMail_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Sell-to E-Mail")
            {
            }
            column(NoSeries_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO No. Series")
            {
            }
            column(Status_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Status")
            {
            }
            column(PurchaseReceiptNo_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Purchase Receipt No.")
            {
            }
            column(VendorNo_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Vendor No.")
            {
            }
            column(VendorName_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Vendor Name")
            {
            }
            column(PackageTrackingNo_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Package Tracking No.")
            {
            }
            column(ShiptoCode_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Ship-to Code")
            {
            }
            column(ShiptoName_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Ship-to Name")
            {
            }
            column(ShiptoName2_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Ship-to Name 2")
            {
            }
            column(ShiptoAddress_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Ship-to Address")
            {
            }
            column(ShiptoAddress2_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Ship-to Address 2")
            {
            }
            column(ShiptoCity_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Ship-to City")
            {
            }
            column(ShiptoContact_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Ship-to Contact")
            {
            }
            column(ShiptoPostCode_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Ship-to Post Code")
            {
            }
            column(ShiptoCounty_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Ship-to County")
            {
            }
            column(ShiptoCountryRegionCode_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Ship-to C./R. Code")
            {
            }
            column(ShipmentDate_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Shipment Date")
            {
            }
            column(ShipmentMethodCode_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Shipment Method Code")
            {
            }
            column(ShippingAgentCode_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Shipping Agent Code")
            {
            }
            column(CompanyLogo; CompanyInfo.Picture)
            {
            }
            column(CompanyAddress_Array_1; CompanyAddress[1])
            {
            }
            column(CompanyAddress_Array_2; CompanyAddress[2])
            {
            }
            column(CompanyAddress_Array_3; CompanyAddress[3])
            {
            }
            column(CompanyAddress_Array_4; CompanyAddress[4])
            {
            }
            column(CompanyAddress_Array_5; CompanyAddress[5])
            {
            }
            column(CompanyAddress_Array_6; CompanyAddress[6])
            {
            }
            column(CompanyAddress_Array_7; CompanyAddress[7])
            {
            }
            column(CompanyAddress_Array_8; CompanyAddress[8])
            {
            }
            column(ClosedDate_ServiceWarrantyHdr; ClosedDate)
            {
            }
            dataitem("Service & Warranty Comments"; "LGX ZMO Service Warr. Comment")
            {
                DataItemLink = "LGX ZMO No." = field("LGX ZMO Incident No.");
                DataItemTableView = sorting("LGX ZMO Table Name", "LGX ZMO No.", "LGX ZMO Line No.");
                MaxIteration = 1;
                column(Comment_ServiceWarrantyComments; "Service & Warranty Comments"."LGX ZMO Comment")
                {
                }
                column(Date_ServiceWarrantyComments; "Service & Warranty Comments"."LGX ZMO Date")
                {
                }
                column(IncidentComments; IncidentComments)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                Clear(IncidentComments);
                ServiceWarrantyComments.Reset();
                ServiceWarrantyComments.SetRange("LGX ZMO No.", "LGX ZMO Incident No.");
                if ServiceWarrantyComments.FindSet() then
                    repeat
                        IncidentComments += Format(ServiceWarrantyComments."LGX ZMO Date", 10, '<Month,2>/<Day,2>/<Year4>') + ': ' + ServiceWarrantyComments."LGX ZMO Comment" + ' ';
                    until ServiceWarrantyComments.Next() = 0;

                Clear(ClosedDate);
                if "LGX ZMO Status" = "LGX ZMO Status"::Closed then begin
                    ServiceWarrantyComments2.Reset();
                    ServiceWarrantyComments2.SetRange("LGX ZMO No.", "LGX ZMO Incident No.");
                    if ServiceWarrantyComments2.FindLast() then
                        ClosedDate := ServiceWarrantyComments2."LGX ZMO Date";
                end;
            end;

            trigger OnPreDataItem();
            begin
                FormatAddress.Company(CompanyAddress, CompanyInfo);
                IF GETFILTER("LGX ZMO Sell-to Customer Name") <> '' then
                    SetFilter("LGX ZMO Sell-to Customer Name", '%1', UPPERCASE(GETFILTER("LGX ZMO Sell-to Customer Name")));
                IF "Service & Warranty Line".GetFilters() <> '' then
                    SetFilter("LGX ZMO Incident No.", "Service & Warranty Line"."LGX ZMO Incident No.");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
    }

    trigger OnPreReport();
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        ServiceWarrantyComments: Record "LGX ZMO Service Warr. Comment";
        ServiceWarrantyComments2: Record "LGX ZMO Service Warr. Comment";
        FormatAddress: Codeunit "Format Address";
        CompanyAddress: array[8] of Text[80];
        IncidentComments: Text;
        ServiceCompanyNo: Code[20];
        ServiceCompanyName: Text[50];
        ClosedDate: Date;

}
