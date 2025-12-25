using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class HospitalDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // При первой загрузке скрываем секции, требующие выбора стационара
                HospitalServicesEntityDataSource.Visible = false;
                HospitalServicesGridView.Visible = false;
                HospitalStatsEntityDataSource.Visible = false;
                HospitalStatsGridView.Visible = false;
            }
        }

        protected void HospitalsGridView_SelectedIndexChanged(object sender, EventArgs e)
        {
            // При выборе стационара показываем связанные секции
            HospitalServicesEntityDataSource.Visible = true;
            HospitalServicesGridView.Visible = true;
            HospitalStatsEntityDataSource.Visible = true;
            HospitalStatsGridView.Visible = true;
        }
    }
} 