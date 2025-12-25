<%@ Page Title="Отчеты по пациентам" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PatientReport.aspx.cs" Inherits="WebApplication1.PatientReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Отчеты по пациентам</h2>
    
    <div>
        <h3>Фильтр по пациентам</h3>
        
        <asp:EntityDataSource ID="PatientsEntityDataSource" runat="server"
            ConnectionString="name=KlinikaEntities"
            DefaultContainerName="KlinikaEntities"
            EnableFlattening="False"
            EntitySetName="Patients"
            OrderBy="it.LastName, it.FirstName, it.MiddleName">
        </asp:EntityDataSource>
        
        <table>
            <tr>
                <td>Выберите пациента:</td>
                <td>
                    <asp:DropDownList ID="PatientsDropDownList" runat="server"
                        DataSourceID="PatientsEntityDataSource"
                        DataTextField="LastName"
                        DataValueField="PatientID"
                        AppendDataBoundItems="true">
                        <asp:ListItem Text="-- Все пациенты --" Value="0" />
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td>Дата начала:</td>
                <td>
                    <asp:TextBox ID="StartDateTextBox" runat="server" TextMode="Date"></asp:TextBox>
                    <asp:CompareValidator ID="StartDateValidator" runat="server"
                        ControlToValidate="StartDateTextBox"
                        Type="Date"
                        Operator="DataTypeCheck"
                        ErrorMessage="Введите корректную дату"
                        Display="Dynamic"
                        CssClass="validation-error">
                    </asp:CompareValidator>
                </td>
            </tr>
            <tr>
                <td>Дата окончания:</td>
                <td>
                    <asp:TextBox ID="EndDateTextBox" runat="server" TextMode="Date"></asp:TextBox>
                    <asp:CompareValidator ID="EndDateValidator" runat="server"
                        ControlToValidate="EndDateTextBox"
                        Type="Date"
                        Operator="DataTypeCheck"
                        ErrorMessage="Введите корректную дату"
                        Display="Dynamic"
                        CssClass="validation-error">
                    </asp:CompareValidator>
                    <asp:CompareValidator ID="DateRangeValidator" runat="server"
                        ControlToValidate="EndDateTextBox"
                        ControlToCompare="StartDateTextBox"
                        Type="Date"
                        Operator="GreaterThanEqual"
                        ErrorMessage="Дата окончания должна быть не раньше даты начала"
                        Display="Dynamic"
                        CssClass="validation-error">
                    </asp:CompareValidator>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <asp:Button ID="GenerateReportButton" runat="server" Text="Сформировать отчет" OnClick="GenerateReportButton_Click" />
                </td>
            </tr>
        </table>
        
        <asp:Label ID="ErrorMessageLabel" runat="server" Text="" ForeColor="Red" Visible="false"></asp:Label>
    </div>
    
    <div>
        <h3>Результаты отчета</h3>
        
        <asp:EntityDataSource ID="ReportEntityDataSource" runat="server"
            ConnectionString="name=KlinikaEntities"
            DefaultContainerName="KlinikaEntities"
            EnableFlattening="False"
            EntitySetName="MedicalHospitalServices"
            Include="Patient,MedicalService,Hospital"
            Where="(@PatientID = 0 OR it.PatientID = @PatientID) AND (it.ServiceDate >= @StartDate AND it.ServiceDate <= @EndDate)"
            OrderBy="it.ServiceDate DESC">
            <WhereParameters>
                <asp:ControlParameter ControlID="PatientsDropDownList" Name="PatientID" PropertyName="SelectedValue" Type="Int32" DefaultValue="0" />
                <asp:ControlParameter ControlID="StartDateTextBox" Name="StartDate" PropertyName="Text" Type="DateTime" />
                <asp:ControlParameter ControlID="EndDateTextBox" Name="EndDate" PropertyName="Text" Type="DateTime" />
            </WhereParameters>
        </asp:EntityDataSource>
        
        <asp:Panel ID="ReportPanel" runat="server" Visible="false">
            <h3>
                <asp:Label ID="ReportTitleLabel" runat="server" Text=""></asp:Label>
            </h3>
            
            <asp:GridView ID="ReportGridView" runat="server"
                DataSourceID="ReportEntityDataSource"
                AutoGenerateColumns="False"
                AllowPaging="True"
                AllowSorting="True"
                EmptyDataText="Нет данных для отображения">
                <Columns>
                    <asp:BoundField DataField="ServiceDate" HeaderText="Дата" SortExpression="ServiceDate" DataFormatString="{0:d}" />
                    <asp:TemplateField HeaderText="Пациент" SortExpression="PatientID">
                        <ItemTemplate>
                            <asp:Label ID="PatientNameLabel" runat="server" Text='<%# String.Format("{0} {1} {2}", Eval("Patient.LastName"), Eval("Patient.FirstName"), Eval("Patient.MiddleName")) %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Услуга" SortExpression="ServiceID">
                        <ItemTemplate>
                            <asp:Label ID="ServiceNameLabel" runat="server" Text='<%# Eval("MedicalService.Name") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Стационар" SortExpression="HospitalID">
                        <ItemTemplate>
                            <asp:Label ID="HospitalNameLabel" runat="server" Text='<%# Eval("Hospital.Name") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="AssignedBy" HeaderText="Назначил" SortExpression="AssignedBy" />
                    <asp:BoundField DataField="Performed" HeaderText="Выполнил" SortExpression="Performed" />
                    <asp:BoundField DataField="Quantity" HeaderText="Количество" SortExpression="Quantity" />
                    <asp:TemplateField HeaderText="Стоимость">
                        <ItemTemplate>
                            <asp:Label ID="CostLabel" runat="server" Text='<%# String.Format("{0:C}", Convert.ToDecimal(Eval("Quantity")) * Convert.ToDecimal(Eval("MedicalService.Cost"))) %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            
            <br />
            <div style="text-align: right; font-weight: bold;">
                Общая стоимость: <asp:Label ID="TotalCostLabel" runat="server" Text=""></asp:Label>
            </div>
            
            <div style="margin-top: 20px;">
                <asp:Button ID="ExportToPdfButton" runat="server" Text="Экспорт в PDF" OnClick="ExportToPdfButton_Click" />
                <asp:Button ID="ExportToExcelButton" runat="server" Text="Экспорт в Excel" OnClick="ExportToExcelButton_Click" />
            </div>
        </asp:Panel>
    </div>
</asp:Content> 