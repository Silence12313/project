<%@ Page Title="Персонал" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Staff.aspx.cs" Inherits="WebApplication1.Staff" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Медицинский персонал</h2>
    
    <div>
        <asp:EntityDataSource ID="StaffEntityDataSource" runat="server"
            ConnectionString="name=KlinikaEntities"
            DefaultContainerName="KlinikaEntities"
            EnableFlattening="False"
            EntitySetName="Staff"
            EnableUpdate="True"
            OrderBy="it.FullName"
            OnSelected="StaffEntityDataSource_Selected">
        </asp:EntityDataSource>
        
        <asp:GridView ID="StaffGridView" runat="server"
            DataSourceID="StaffEntityDataSource"
            AutoGenerateColumns="False"
            DataKeyNames="StaffID"
            AllowPaging="True"
            AllowSorting="True"
            SelectedRowStyle-BackColor="LightGray"
            OnSelectedIndexChanged="StaffGridView_SelectedIndexChanged"
            OnRowUpdating="StaffGridView_RowUpdating">
            <Columns>
                <asp:CommandField ShowSelectButton="True" ShowEditButton="True" />
                <asp:BoundField DataField="StaffID" HeaderText="ID" ReadOnly="True" SortExpression="StaffID" />
                <asp:BoundField DataField="FullName" HeaderText="ФИО" SortExpression="FullName" />
                <asp:BoundField DataField="Position" HeaderText="Должность" SortExpression="Position" />
                <asp:BoundField DataField="Phone" HeaderText="Телефон" SortExpression="Phone" />
            </Columns>
            <SelectedRowStyle BackColor="LightGray"></SelectedRowStyle>
        </asp:GridView>
        
        <asp:Label ID="ErrorMessageLabel" runat="server" Text="" Visible="false" ViewStateMode="Disabled"></asp:Label>
    </div>
    
    <h3>Назначенные услуги</h3>
    
    <div>
        <asp:EntityDataSource ID="AssignedServicesEntityDataSource" runat="server"
            ConnectionString="name=KlinikaEntities"
            DefaultContainerName="KlinikaEntities"
            EnableFlattening="False"
            EntitySetName="MedicalHospitalServices"
            Where="it.AssignedBy = @StaffName"
            Include="MedicalService,Patient,Hospital">
            <WhereParameters>
                <asp:ControlParameter ControlID="StaffGridView" Name="StaffName" PropertyName="SelectedDataKey.Values[1]" Type="String" DefaultValue="" />
            </WhereParameters>
        </asp:EntityDataSource>
        
        <asp:GridView ID="AssignedServicesGridView" runat="server"
            DataSourceID="AssignedServicesEntityDataSource"
            AutoGenerateColumns="False"
            DataKeyNames="DocumentID"
            AllowPaging="True"
            AllowSorting="True"
            SelectedRowStyle-BackColor="LightGray"
            OnSelectedIndexChanged="AssignedServicesGridView_SelectedIndexChanged">
            <EmptyDataTemplate>
                <p>Услуги не назначены.</p>
            </EmptyDataTemplate>
            <Columns>
                <asp:CommandField ShowSelectButton="True" />
                <asp:BoundField DataField="DocumentID" HeaderText="ID" ReadOnly="True" SortExpression="DocumentID" />
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
                <asp:TemplateField HeaderText="Стационар" SortExpression="HospitalID">
                    <ItemTemplate>
                        <asp:Label ID="HospitalNameLabel" runat="server" Text='<%# Eval("Hospital.Name") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Performed" HeaderText="Выполнил" SortExpression="Performed" />
                <asp:BoundField DataField="Quantity" HeaderText="Количество" SortExpression="Quantity" />
            </Columns>
            <SelectedRowStyle BackColor="LightGray"></SelectedRowStyle>
        </asp:GridView>
    </div>
    
    <h3>Детали услуги</h3>
    
    <div>
        <asp:EntityDataSource ID="ServiceDetailsEntityDataSource" runat="server"
            ConnectionString="name=KlinikaEntities"
            DefaultContainerName="KlinikaEntities"
            EnableFlattening="False"
            EntitySetName="MedicalHospitalServices"
            Where="it.DocumentID = @DocumentID"
            Include="MedicalService,Patient,Hospital">
            <WhereParameters>
                <asp:ControlParameter ControlID="AssignedServicesGridView" Name="DocumentID" PropertyName="SelectedValue" Type="Int32" DefaultValue="0" />
            </WhereParameters>
        </asp:EntityDataSource>
        
        <asp:DetailsView ID="ServiceDetailsView" runat="server"
            DataSourceID="ServiceDetailsEntityDataSource"
            AutoGenerateRows="False">
            <EmptyDataTemplate>
                <p>Выберите услугу для просмотра деталей.</p>
            </EmptyDataTemplate>
            <Fields>
                <asp:BoundField DataField="DocumentID" HeaderText="ID документа" ReadOnly="True" />
                <asp:BoundField DataField="ServiceDate" HeaderText="Дата" DataFormatString="{0:d}" />
                <asp:TemplateField HeaderText="Услуга">
                    <ItemTemplate>
                        <asp:Label ID="DetailServiceNameLabel" runat="server" Text='<%# Eval("MedicalService.Name") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Пациент">
                    <ItemTemplate>
                        <asp:Label ID="DetailPatientNameLabel" runat="server" Text='<%# String.Format("{0} {1} {2}", Eval("Patient.LastName"), Eval("Patient.FirstName"), Eval("Patient.MiddleName")) %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="AssignedBy" HeaderText="Назначил" />
                <asp:BoundField DataField="Performed" HeaderText="Выполнил" />
                <asp:TemplateField HeaderText="Стационар">
                    <ItemTemplate>
                        <asp:Label ID="DetailHospitalNameLabel" runat="server" Text='<%# Eval("Hospital.Name") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Quantity" HeaderText="Количество" />
            </Fields>
        </asp:DetailsView>
    </div>
    
    <h3>Пациенты, получившие услугу</h3>
    
    <div>
        <asp:EntityDataSource ID="PatientsWithServiceEntityDataSource" runat="server"
            ConnectionString="name=KlinikaEntities"
            DefaultContainerName="KlinikaEntities"
            EnableFlattening="False"
            EntitySetName="MedicalHospitalServices"
            Where="it.ServiceID = @ServiceID AND it.DocumentID <> @DocumentID"
            Include="Patient">
            <WhereParameters>
                <asp:ControlParameter ControlID="ServiceDetailsEntityDataSource" Name="ServiceID" PropertyName="SelectedValue.ServiceID" Type="Int32" DefaultValue="0" />
                <asp:ControlParameter ControlID="AssignedServicesGridView" Name="DocumentID" PropertyName="SelectedValue" Type="Int32" DefaultValue="0" />
            </WhereParameters>
        </asp:EntityDataSource>
        
        <asp:ListView ID="PatientsListView" runat="server" DataSourceID="PatientsWithServiceEntityDataSource">
            <EmptyDataTemplate>
                <p>Нет других пациентов, получивших эту услугу.</p>
            </EmptyDataTemplate>
            <LayoutTemplate>
                <ul>
                    <li runat="server" id="itemPlaceholder"></li>
                </ul>
            </LayoutTemplate>
            <ItemTemplate>
                <li>
                    <asp:Label ID="PatientNameListLabel" runat="server" Text='<%# String.Format("{0} {1} {2} - {3:d}", Eval("Patient.LastName"), Eval("Patient.FirstName"), Eval("Patient.MiddleName"), Eval("ServiceDate")) %>'></asp:Label>
                </li>
            </ItemTemplate>
        </asp:ListView>
    </div>
</asp:Content> 