using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace WebApplication1
{
    public partial class Staff : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // При первой загрузке скрываем элементы, требующие выбора сотрудника
                AssignedServicesEntityDataSource.Visible = false;
                AssignedServicesGridView.Visible = false;
                ServiceDetailsEntityDataSource.Visible = false;
                ServiceDetailsView.Visible = false;
                PatientsWithServiceEntityDataSource.Visible = false;
                PatientsListView.Visible = false;
            }
        }

        protected void StaffEntityDataSource_Selected(object sender, EntityDataSourceSelectedEventArgs e)
        {
            // Проверка на наличие данных
            if (e.TotalRowCount == 0)
            {
                ErrorMessageLabel.Text = "В базе данных нет информации о персонале.";
                ErrorMessageLabel.Visible = true;
            }
            else
            {
                ErrorMessageLabel.Visible = false;
            }
        }

        protected void StaffGridView_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Показываем секцию назначенных услуг при выборе сотрудника
            AssignedServicesEntityDataSource.Visible = true;
            AssignedServicesGridView.Visible = true;
            
            // Скрываем детали услуги и пациентов, пока не выбрана услуга
            ServiceDetailsEntityDataSource.Visible = false;
            ServiceDetailsView.Visible = false;
            PatientsWithServiceEntityDataSource.Visible = false;
            PatientsListView.Visible = false;
        }

        protected void AssignedServicesGridView_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Показываем детали услуги и связанных пациентов при выборе услуги
            ServiceDetailsEntityDataSource.Visible = true;
            ServiceDetailsView.Visible = true;
            PatientsWithServiceEntityDataSource.Visible = true;
            PatientsListView.Visible = true;
        }

        protected void StaffGridView_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // Проверка валидности номера телефона
            if (e.NewValues["Phone"] != null)
            {
                string phone = e.NewValues["Phone"].ToString();
                if (!IsValidPhoneNumber(phone))
                {
                    e.Cancel = true;
                    ErrorMessageLabel.Text = "Неверный формат номера телефона. Используйте формат +7XXXXXXXXXX или 8XXXXXXXXXX";
                    ErrorMessageLabel.Visible = true;
                }
            }
        }

        private bool IsValidPhoneNumber(string phone)
        {
            // Простая проверка формата телефона
            if (string.IsNullOrEmpty(phone))
                return true; // Допускаем пустые значения
                
            return System.Text.RegularExpressions.Regex.IsMatch(phone, @"^(\+7|8)\d{10}$");
        }
    }
} 