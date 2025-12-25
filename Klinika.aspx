<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Klinika.aspx.cs" Inherits="WebApplication1.Klinika" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h2>
Список пациентов</h2>
    <asp:EntityDataSource ID="PacientDS" runat="server" 
        ConnectionString="name=KlinikaEntities" DefaultContainerName="KlinikaEntities" 
        EnableDelete="True" EnableFlattening="False" EnableUpdate="True" 
        EntitySetName="Pacients">
    </asp:EntityDataSource>
</asp:Content>


