using System;
using System.IO;
using System.Web.UI;
using Microsoft.ClearScript.V8;


namespace Prueba
{

    public partial class Prueba_Firma : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                // Retrieve the drawn image data from the hidden field
                string imageData = HiddenField1.Value;
            }
        }

        protected void Btn_Cursor_Click(object sender, EventArgs e)
        {
            FirmaDigital(0,600,200);
        }
        
        protected void Btn_Tablet_Click(object sender, EventArgs e)
        {
            FirmaDigital(1,600,200);

        }

        protected void BtnClear_Click(object sender, EventArgs e)
        {
            ClearCanvas();
        }

        protected void Btn_Save_Click(object sender, EventArgs e)
        {
            GuardarFirma(@"~/Firmas", TextBox1.Text);
        }

        protected void OK_Btn_Click(object sender, EventArgs e)
        {
            Done();
            
        }

        /// <summary>
        /// Realiza la firma digital, el flujo de control (si se firma con o sin tableta) y
        /// cambia el tamaño del canvas según el ancho y alto especificados.
        /// </summary>
        /// <param name="Mode">Modo de firma: 1 si se usa tableta, 0 si no.</param>
        /// <param name="xCanvas">Ancho del canvas en píxeles.</param>
        /// <param name="yCanvas">Alto del canvas en píxeles.</param>
        protected void FirmaDigital(int Mode, int xCanvas, int yCanvas)
        {
            //con tableta
            if (Mode == 1)
            {
                dibujarConTableta(xCanvas,yCanvas);
            }

            //sin tableta
            else if (Mode == 0)
            {
                dibujarConCursor(xCanvas,yCanvas);
            };
        }

        protected void Done()
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), $"Done();endDemo(); close();", true);
        }
 
        
        void dibujarConTableta(int xCanvas, int yCanvas)
        {
            ClearCanvas();


            //llamar a funcion de javascript para tableta
            ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), $"onSign({xCanvas},{yCanvas});", true);



        }




        /// <summary>
        /// Prepara el canvas 'mycanvas' para dibujar utilizando la firma sin tableta.
        /// </summary>
        void dibujarConCursor(int xCanvas,int yCanvas)
        {
            ClearCanvas();
            ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), $"alert(\"Se esta usando el cursor\"); CursorSign({xCanvas},{yCanvas})", true);
        }


        /// <summary>
        /// Limpia el contenido del canvas 'mycanvas' estableciendo el valor del campo oculto en vacío.
        /// </summary>
        protected void ClearCanvas()
        {
            HiddenField1.Value = string.Empty;
        }



        /// <summary>
        /// Guarda la firma digital en un archivo en la ubicación especificada desde un
        /// (HiddenField) que tiene datos de imagen codificados en base64
        /// </summary>
        /// <param name="outputPath">Path de la carpeta de destino para guardar la firma.</param>
        /// <param name="name">Nombre del archivo de firma / nombre de paciente (sin extensión).</param>
        protected void GuardarFirma(string outputPath, string name)
        {

            

            string imageData = HiddenField1.Value;

            // conversion: datos de imagen codificados en base64 a matriz de bytes
            byte[] imageBytes = Convert.FromBase64String(imageData);

            string DownloadPath = Server.MapPath(outputPath + @"\" + name + ".jpg");


            File.WriteAllBytes(DownloadPath, imageBytes);
           

        }


    }
}