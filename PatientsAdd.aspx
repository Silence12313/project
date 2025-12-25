<%@ Page Title="Добавление пациента" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PatientsAdd.aspx.cs" Inherits="WebApplication1.PatientsAdd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Добавление нового пациента</h2>
    
    <div>
        <asp:EntityDataSource ID="PatientsEntityDataSource" runat="server"
            ConnectionString="name=KlinikaEntities"
            DefaultContainerName="KlinikaEntities"
            EnableFlattening="False"
            EntitySetName="Patients"
            EnableInsert="True">
        </asp:EntityDataSource>
        
        <asp:DetailsView ID="PatientsDetailsView" runat="server"
            DataSourceID="PatientsEntityDataSource" 
            AutoGenerateRows="False"
            DefaultMode="Insert">
            <Fields>
                <asp:BoundField DataField="LastName" HeaderText="Фамилия" SortExpression="LastName" />
                <asp:BoundField DataField="FirstName" HeaderText="Имя" SortExpression="FirstName" />
                <asp:BoundField DataField="MiddleName" HeaderText="Отчество" SortExpression="MiddleName" />
                <asp:BoundField DataField="PolicyNumber" HeaderText="№ полиса ОМС" SortExpression="PolicyNumber" />
                <asp:BoundField DataField="Address" HeaderText="Адрес" SortExpression="Address" />
                <asp:BoundField DataField="Phone" HeaderText="Телефон" SortExpression="Phone" />
                <asp:CommandField ShowInsertButton="True" />
            </Fields>
        </asp:DetailsView>
    </div>
</asp:Content> 