<%@ Page Title="Медицинские услуги" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MedicalServices.aspx.cs" Inherits="WebApplication1.MedicalServices" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Медицинские услуги</h2>
    
    <div>
        <asp:EntityDataSource ID="MedicalServicesEntityDataSource" runat="server"
            ConnectionString="name=KlinikaEntities"
            DefaultContainerName="KlinikaEntities"
            EnableFlattening="False"
            EntitySetName="MedicalServices"
            EnableUpdate="True"
            EnableDelete="True">
        </asp:EntityDataSource>
        
        <asp:GridView ID="MedicalServicesGridView" runat="server"
            DataSourceID="MedicalServicesEntityDataSource"
            AutoGenerateColumns="False"
            DataKeyNames="ServiceID"
            AllowPaging="True"
            AllowSorting="True">
            <Columns>
                <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" />
                <asp:BoundField DataField="ServiceID" HeaderText="ID" ReadOnly="True" SortExpression="ServiceID" />
                <asp:BoundField DataField="Name" HeaderText="Наименование" SortExpression="Name" />
                <asp:BoundField DataField="Cost" HeaderText="Стоимость" SortExpression="Cost" DataFormatString="{0:C}" />
                <asp:BoundField DataField="Unit" HeaderText="Ед. измерения" SortExpression="Unit" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content> 