using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data;
using System.Web.UI.HtmlControls;
using System.Text;

namespace WebApplication1
{
    public partial class PatientReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Установка начальных дат по умолчанию
                StartDateTextBox.Text = DateTime.Today.AddMonths(-1).ToString("yyyy-MM-dd");
                EndDateTextBox.Text = DateTime.Today.ToString("yyyy-MM-dd");
            }
        }

        protected void GenerateReportButton_Click(object sender, EventArgs e)
        {
            // Валидация дат
            DateTime startDate, endDate;
            if (!DateTime.TryParse(StartDateTextBox.Text, out startDate) || 
                !DateTime.TryParse(EndDateTextBox.Text, out endDate))
            {
                ErrorMessageLabel.Text = "Пожалуйста, введите корректные даты.";
                ErrorMessageLabel.Visible = true;
                ReportPanel.Visible = false;
                return;
            }

            if (startDate > endDate)
            {
                ErrorMessageLabel.Text = "Дата начала не может быть позднее даты окончания.";
                ErrorMessageLabel.Visible = true;
                ReportPanel.Visible = false;
                return;
            }

            // Формирование заголовка отчета
            if (PatientsDropDownList.SelectedValue == "0")
            {
                ReportTitleLabel.Text = String.Format("Отчет по всем пациентам с {0:d} по {1:d}", startDate, endDate);
            }
            else
            {
                ListItem selectedPatient = PatientsDropDownList.SelectedItem;
                ReportTitleLabel.Text = String.Format("Отчет по пациенту {0} с {1:d} по {2:d}", 
                    selectedPatient.Text, startDate, endDate);
            }

            // Показ панели отчета
            ErrorMessageLabel.Visible = false;
            ReportPanel.Visible = true;

            // Расчет общей стоимости
            CalculateTotalCost();
        }

        private void CalculateTotalCost()
        {
            decimal totalCost = 0;

            // Использование EntityDataSource для получения данных
            ReportEntityDataSource.DataBind();
            
            using (DAL.KlinikaEntities context = new DAL.KlinikaEntities())
            {
                // Формирование запроса для расчета общей стоимости
                int patientID = Convert.ToInt32(PatientsDropDownList.SelectedValue);
                DateTime startDate = Convert.ToDateTime(StartDateTextBox.Text);
                DateTime endDate = Convert.ToDateTime(EndDateTextBox.Text);
                
                var query = from service in context.MedicalHospitalServices
                            join medService in context.MedicalServices on service.ServiceID equals medService.ServiceID
                            where (patientID == 0 || service.PatientID == patientID) &&
                                  (service.ServiceDate >= startDate && service.ServiceDate <= endDate)
                            select new { Cost = service.Quantity * medService.Cost };
                
                totalCost = query.Sum(item => item.Cost);
            }

            TotalCostLabel.Text = String.Format("{0:C}", totalCost);
        }

        protected void ExportToPdfButton_Click(object sender, EventArgs e)
        {
            // Формирование PDF-файла
            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", "attachment;filename=PatientReport.pdf");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);

            StringWriter sw = new StringWriter();
            HtmlTextWriter hw = new HtmlTextWriter(sw);

            // Создание "PDF-документа"
            StringBuilder sb = new StringBuilder();
            sb.Append("<div style='text-align:center;font-size:18px;font-weight:bold;'>");
            sb.Append(ReportTitleLabel.Text);
            sb.Append("</div><br/>");

            // Добавление таблицы
            ReportGridView.RenderControl(hw);
            sb.Append(sw.ToString());

            // Добавление итоговой стоимости
            sb.Append("<div style='text-align:right;font-weight:bold;'>");
            sb.Append("Общая стоимость: " + TotalCostLabel.Text);
            sb.Append("</div>");

            // В реальном приложении здесь будет код для генерации PDF
            // Для лабораторной работы просто создаем текстовый HTML-документ
            Response.ContentType = "text/html";
            Response.Write(sb.ToString());
            Response.End();
        }

        protected void ExportToExcelButton_Click(object sender, EventArgs e)
        {
            // Формирование Excel-файла
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=PatientReport.xls");
            Response.Charset = "";
            Response.ContentType = "application/vnd.ms-excel";

            StringWriter sw = new StringWriter();
            HtmlTextWriter hw = new HtmlTextWriter(sw);

            // Добавление заголовка
            hw.WriteLine("<h2>" + ReportTitleLabel.Text + "</h2>");

            // Добавление таблицы
            ReportGridView.RenderControl(hw);

            // Добавление итоговой стоимости
            hw.WriteLine("<p style='text-align:right;font-weight:bold;'>Общая стоимость: " + TotalCostLabel.Text + "</p>");

            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();
        }

        public override void VerifyRenderingInServerForm(Control control)
        {
            // Необходимо для экспорта GridView
        }
    }
} 