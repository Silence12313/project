<%@ Page Title="Стационары" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="HospitalDetails.aspx.cs" Inherits="WebApplication1.HospitalDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Стационары</h2>
    
    <div>
        <asp:EntityDataSource ID="HospitalsEntityDataSource" runat="server"
            ConnectionString="name=KlinikaEntities"
            DefaultContainerName="KlinikaEntities"
            EnableFlattening="False"
            EntitySetName="Hospitals"
            EnableUpdate="True"
            EnableDelete="True"
            EnableInsert="True"
            OrderBy="it.Name">
        </asp:EntityDataSource>
        
        <asp:GridView ID="HospitalsGridView" runat="server"
            DataSourceID="HospitalsEntityDataSource"
            AutoGenerateColumns="False"
            DataKeyNames="HospitalID"
            AllowPaging="True"
            AllowSorting="True"
            SelectedRowStyle-BackColor="LightGray"
            OnSelectedIndexChanged="HospitalsGridView_SelectedIndexChanged">
            <Columns>
                <asp:CommandField ShowSelectButton="True" ShowEditButton="True" ShowDeleteButton="True" />
                <asp:BoundField DataField="HospitalID" HeaderText="ID" ReadOnly="True" SortExpression="HospitalID" />
                <asp:BoundField DataField="Name" HeaderText="Название" SortExpression="Name" />
                <asp:BoundField DataField="Address" HeaderText="Адрес" SortExpression="Address" />
                <asp:BoundField DataField="Phone" HeaderText="Телефон" SortExpression="Phone" />
            </Columns>
            <SelectedRowStyle BackColor="LightGray"></SelectedRowStyle>
        </asp:GridView>
        
        <br />
        <h3>Добавление нового стационара</h3>
        <asp:DetailsView ID="HospitalsDetailsView" runat="server"
            DataSourceID="HospitalsEntityDataSource"
            AutoGenerateRows="False"
            DefaultMode="Insert">
            <Fields>
                <asp:BoundField DataField="Name" HeaderText="Название" SortExpression="Name" />
                <asp:BoundField DataField="Address" HeaderText="Адрес" SortExpression="Address" />
                <asp:BoundField DataField="Phone" HeaderText="Телефон" SortExpression="Phone" />
                <asp:CommandField ShowInsertButton="True" />
            </Fields>
        </asp:DetailsView>
    </div>
    
    <h3>Услуги в стационаре</h3>
    
    <div>
        <asp:EntityDataSource ID="HospitalServicesEntityDataSource" runat="server"
            ConnectionString="name=KlinikaEntities"
            DefaultContainerName="KlinikaEntities"
            EnableFlattening="False"
            EntitySetName="MedicalHospitalServices"
            Where="it.HospitalID = @HospitalID"
            Include="MedicalService,Patient"
            OrderBy="it.ServiceDate DESC">
            <WhereParameters>
                <asp:ControlParameter ControlID="HospitalsGridView" Name="HospitalID" PropertyName="SelectedValue" Type="Int32" DefaultValue="0" />
            </WhereParameters>
        </asp:EntityDataSource>
        
        <asp:GridView ID="HospitalServicesGridView" runat="server"
            DataSourceID="HospitalServicesEntityDataSource"
            AutoGenerateColumns="False"
            DataKeyNames="DocumentID"
            AllowPaging="True"
            AllowSorting="True">
            <EmptyDataTemplate>
                <p>В данном стационаре не оказано ни одной услуги.</p>
            </EmptyDataTemplate>
            <Columns>
                <asp:BoundField DataField="DocumentID" HeaderText="ID документа" ReadOnly="True" SortExpression="DocumentID" />
                <asp:BoundField DataField="ServiceDate" HeaderText="Дата" SortExpression="ServiceDate" DataFormatString="{0:d}" />
                <asp:TemplateField HeaderText="Услуга" SortExpression="ServiceID">
                    <ItemTemplate>
                        <asp:Label ID="ServiceNameLabel" runat="server" Text='<%# Eval("MedicalService.Name") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Пациент" SortExpression="PatientID">
                    <ItemTemplate>
                        <asp:Label ID="PatientNameLabel" runat="server" Text='<%# String.Format("{0} {1} {2}", Eval("Patient.LastName"), Eval("Patient.FirstName"), Eval("Patient.MiddleName")) %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="AssignedBy" HeaderText="Назначил" SortExpression="AssignedBy" />
                <asp:BoundField DataField="Performed" HeaderText="Выполнил" SortExpression="Performed" />
                <asp:BoundField DataField="Quantity" HeaderText="Количество" SortExpression="Quantity" />
            </Columns>
        </asp:GridView>
    </div>
    
    <h3>Статистика услуг по стационару</h3>
    
    <div>
        <asp:EntityDataSource ID="HospitalStatsEntityDataSource" runat="server"
            ConnectionString="name=KlinikaEntities"
            DefaultContainerName="KlinikaEntities"
            EnableFlattening="False"
            EntitySetName="MedicalHospitalServices"
            Where="it.HospitalID = @HospitalID"
            GroupBy="it.ServiceID"
            Select="it.MedicalService.Name as ServiceName, COUNT(it.DocumentID) as DocCount, SUM(it.Quantity) as TotalQuantity"
            OrderBy="TotalQuantity DESC">
            <WhereParameters>
                <asp:ControlParameter ControlID="HospitalsGridView" Name="HospitalID" PropertyName="SelectedValue" Type="Int32" DefaultValue="0" />
            </WhereParameters>
        </asp:EntityDataSource>
        
        <asp:GridView ID="HospitalStatsGridView" runat="server"
            DataSourceID="HospitalStatsEntityDataSource"
            AutoGenerateColumns="False"
            AllowSorting="True">
            <EmptyDataTemplate>
                <p>Нет данных для статистики.</p>
            </EmptyDataTemplate>
            <Columns>
                <asp:BoundField DataField="ServiceName" HeaderText="Услуга" ReadOnly="True" SortExpression="ServiceName" />
                <asp:BoundField DataField="DocCount" HeaderText="Количество назначений" ReadOnly="True" SortExpression="DocCount" />
                <asp:BoundField DataField="TotalQuantity" HeaderText="Общее количество" ReadOnly="True" SortExpression="TotalQuantity" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content> 