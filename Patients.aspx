<%@ Page Title="Пациенты" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Patients.aspx.cs" Inherits="WebApplication1.Patients" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Список пациентов</h2>
    
    <div>
        <asp:EntityDataSource ID="PatientsEntityDataSource" runat="server"
            ConnectionString="name=KlinikaEntities"
            DefaultContainerName="KlinikaEntities"
            EnableFlattening="False"
            EntitySetName="Patients"
            EnableUpdate="True"
            EnableDelete="True">
        </asp:EntityDataSource>
        
        <asp:GridView ID="PatientsGridView" runat="server"
            DataSourceID="PatientsEntityDataSource"
            AutoGenerateColumns="False"
            DataKeyNames="PatientID"
            AllowPaging="True"
            AllowSorting="True">
            <Columns>
                <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" />
                <asp:BoundField DataField="PatientID" HeaderText="ID" ReadOnly="True" SortExpression="PatientID" />
                <asp:BoundField DataField="LastName" HeaderText="Фамилия" SortExpression="LastName" />
                <asp:BoundField DataField="FirstName" HeaderText="Имя" SortExpression="FirstName" />
                <asp:BoundField DataField="MiddleName" HeaderText="Отчество" SortExpression="MiddleName" />
                <asp:BoundField DataField="PolicyNumber" HeaderText="№ полиса ОМС" SortExpression="PolicyNumber" />
                <asp:BoundField DataField="Address" HeaderText="Адрес" SortExpression="Address" />
                <asp:BoundField DataField="Phone" HeaderText="Телефон" SortExpression="Phone" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content> 