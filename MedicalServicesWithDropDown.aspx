<%@ Page Title="Услуги в стационаре" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MedicalServicesWithDropDown.aspx.cs" Inherits="WebApplication1.MedicalServicesWithDropDown" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Медицинские услуги в стационаре</h2>
    
    <div>
        <asp:EntityDataSource ID="MedicalServicesEntityDataSource" runat="server"
            ConnectionString="name=KlinikaEntities"
            DefaultContainerName="KlinikaEntities"
            EnableFlattening="False"
            EntitySetName="MedicalServices">
        </asp:EntityDataSource>
        
        Выберите медицинскую услугу:
        <asp:DropDownList ID="MedicalServicesDropDownList" runat="server"
            DataSourceID="MedicalServicesEntityDataSource"
            DataTextField="Name"
            DataValueField="ServiceID"
            AutoPostBack="true">
        </asp:DropDownList>
        
        <h3>Услуги в стационаре по выбранной услуге</h3>
        
        <asp:EntityDataSource ID="HospitalServicesEntityDataSource" runat="server"
            ConnectionString="name=KlinikaEntities"
            DefaultContainerName="KlinikaEntities"
            EnableFlattening="False"
            EntitySetName="MedicalHospitalServices"
            Include="Patient, Hospital"
            Where="it.ServiceID = @ServiceID">
            <WhereParameters>
                <asp:ControlParameter ControlID="MedicalServicesDropDownList" Name="ServiceID" PropertyName="SelectedValue" Type="Int32" />
            </WhereParameters>
        </asp:EntityDataSource>
        
        <asp:GridView ID="HospitalServicesGridView" runat="server"
            DataSourceID="HospitalServicesEntityDataSource"
            AutoGenerateColumns="False"
            DataKeyNames="DocumentID"
            AllowPaging="True"
            AllowSorting="True">
            <Columns>
                <asp:BoundField DataField="DocumentID" HeaderText="№ документа" ReadOnly="True" SortExpression="DocumentID" />
                <asp:BoundField DataField="ServiceDate" HeaderText="Дата" SortExpression="ServiceDate" DataFormatString="{0:d}" />
                <asp:TemplateField HeaderText="Пациент" SortExpression="PatientID">
                    <ItemTemplate>
                        <asp:Label ID="PatientNameLabel" runat="server" Text='<%# String.Format("{0} {1} {2}", Eval("Patient.LastName"), Eval("Patient.FirstName"), Eval("Patient.MiddleName")) %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="AssignedBy" HeaderText="Назначил" SortExpression="AssignedBy" />
                <asp:BoundField DataField="Performed" HeaderText="Выполнил" SortExpression="Performed" />
                <asp:TemplateField HeaderText="Стационар" SortExpression="HospitalID">
                    <ItemTemplate>
                        <asp:Label ID="HospitalNameLabel" runat="server" Text='<%# Eval("Hospital.Name") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Quantity" HeaderText="Количество" SortExpression="Quantity" />
            </Columns>
        </asp:GridView>
        
        <h3>Оплата по выбранной услуге</h3>
        
        <asp:EntityDataSource ID="PaymentsEntityDataSource" runat="server"
            ConnectionString="name=KlinikaEntities"
            DefaultContainerName="KlinikaEntities"
            EnableFlattening="False"
            EntitySetName="Payments"
            Include="Patient"
            Where="EXISTS(SELECT 1 FROM it.Patient.MedicalHospitalServices WHERE ServiceID = @ServiceID)">
            <WhereParameters>
                <asp:ControlParameter ControlID="MedicalServicesDropDownList" Name="ServiceID" PropertyName="SelectedValue" Type="Int32" />
            </WhereParameters>
        </asp:EntityDataSource>
        
        <asp:GridView ID="PaymentsGridView" runat="server"
            DataSourceID="PaymentsEntityDataSource"
            AutoGenerateColumns="False"
            DataKeyNames="PaymentID"
            AllowPaging="True"
            AllowSorting="True">
            <Columns>
                <asp:BoundField DataField="PaymentID" HeaderText="ID" ReadOnly="True" SortExpression="PaymentID" />
                <asp:BoundField DataField="DocumentNumber" HeaderText="№ документа" SortExpression="DocumentNumber" />
                <asp:TemplateField HeaderText="Пациент" SortExpression="PatientID">
                    <ItemTemplate>
                        <asp:Label ID="PaymentPatientLabel" runat="server" Text='<%# String.Format("{0} {1} {2}", Eval("Patient.LastName"), Eval("Patient.FirstName"), Eval("Patient.MiddleName")) %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="ServiceAgreement" HeaderText="Договор" SortExpression="ServiceAgreement" />
                <asp:BoundField DataField="Amount" HeaderText="Сумма" SortExpression="Amount" DataFormatString="{0:C}" />
                <asp:BoundField DataField="PaymentDate" HeaderText="Дата оплаты" SortExpression="PaymentDate" DataFormatString="{0:d}" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content> 