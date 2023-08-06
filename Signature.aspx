<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Prueba Firma.aspx.cs" Inherits="Prueba.Prueba_Firma" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" sigplusextliteextension-installed="true" sigwebext-installed="true">
<head runat="server">
    <title></title>
    
</head>
<body>
    <form id="form1" runat="server" >
        <div>
            <h1>
                Prueba Firma Digital
            </h1>
        </div>

        <div>

          
            <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
            <asp:Button ID="BtnCursor" runat="server" Text="Cursor" OnClick="Btn_Cursor_Click" />
            <asp:Button ID="BtnTablet" runat="server" Text="Tableta" OnClick="Btn_Tablet_Click" />
           
    
            <asp:HiddenField ID="HiddenField1" runat="server" />

            <table border="1" cellpadding="0">
                <tr>
                  <td>
                    <canvas id="mycanvas" name="cnv"></canvas>
                  </td>
                </tr>
            </table>


            <script type="text/javascript" src="SigWebTablet.js"></script>
            <script type="text/javascript">

                var tmr;
                var canvas = document.getElementById("mycanvas");

                var resetIsSupported = false;
                var SigWeb_1_6_4_0_IsInstalled = false; //SigWeb 1.6.4.0 and above add the Reset() and GetSigWebVersion functions
                var SigWeb_1_7_0_0_IsInstalled = false; //SigWeb 1.7.0.0 and above add the GetDaysUntilCertificateExpires() function

                window.onload = function () {
                    if (IsSigWebInstalled()) {
                        var sigWebVer = "";
                        try {
                            sigWebVer = GetSigWebVersion();
                        } catch (err) { console.log("Unable to get SigWeb Version: " + err.message) }

                        if (sigWebVer != "") {
                            try {
                                SigWeb_1_7_0_0_IsInstalled = isSigWeb_1_7_0_0_Installed(sigWebVer);
                            } catch (err) { console.log(err.message) };
                            //if SigWeb 1.7.0.0 is installed, then enable corresponding functionality
                            if (SigWeb_1_7_0_0_IsInstalled) {

                                resetIsSupported = true;
                                try {
                                    var daysUntilCertExpires = GetDaysUntilCertificateExpires();
                                    document.getElementById("daysUntilExpElement").innerHTML = "SigWeb Certificate expires in " + daysUntilCertExpires + " days.";
                                } catch (err) { console.log(err.message) };
                                var note = document.getElementById("sigWebVrsnNote");
                                note.innerHTML = "SigWeb 1.7.0 installed";
                            } else {
                                try {
                                    SigWeb_1_6_4_0_IsInstalled = isSigWeb_1_6_4_0_Installed(sigWebVer);
                                    //if SigWeb 1.6.4.0 is installed, then enable corresponding functionality						
                                } catch (err) { console.log(err.message) };
                                if (SigWeb_1_6_4_0_IsInstalled) {
                                    resetIsSupported = true;
                                    var sigweb_link = document.createElement("a");
                                    sigweb_link.href = "https://www.topazsystems.com/software/sigweb.exe";
                                    sigweb_link.innerHTML = "https://www.topazsystems.com/software/sigweb.exe";

                                    var note = document.getElementById("sigWebVrsnNote");
                                    note.innerHTML = "SigWeb 1.6.4 is installed. Install the newer version of SigWeb from the following link: ";
                                    note.appendChild(sigweb_link);
                                } else {
                                    var sigweb_link = document.createElement("a");
                                    sigweb_link.href = "https://www.topazsystems.com/software/sigweb.exe";
                                    sigweb_link.innerHTML = "https://www.topazsystems.com/software/sigweb.exe";

                                    var note = document.getElementById("sigWebVrsnNote");
                                    note.innerHTML = "A newer version of SigWeb is available. Please uninstall the currently installed version of SigWeb and then install the new version of SigWeb from the following link: ";
                                    note.appendChild(sigweb_link);
                                }
                            }
                        } else {
                            //Older version of SigWeb installed that does not support retrieving the version of SigWeb (Version 1.6.0.2 and older)
                            var sigweb_link = document.createElement("a");
                            sigweb_link.href = "https://www.topazsystems.com/software/sigweb.exe";
                            sigweb_link.innerHTML = "https://www.topazsystems.com/software/sigweb.exe";

                            var note = document.getElementById("sigWebVrsnNote");
                            note.innerHTML = "A newer version of SigWeb is available. Please uninstall the currently installed version of SigWeb and then install the new version of SigWeb from the following link: ";
                            note.appendChild(sigweb_link);
                        }
                    }
                    else {
                        alert("Unable to communicate with SigWeb. Please confirm that SigWeb is installed and running on this PC.");
                    }
                }

                function isSigWeb_1_6_4_0_Installed(sigWebVer) {
                    var minSigWebVersionResetSupport = "1.6.4.0";

                    if (isOlderSigWebVersionInstalled(minSigWebVersionResetSupport, sigWebVer)) {
                        console.log("SigWeb version 1.6.4.0 or higher not installed.");
                        return false;
                    }
                    return true;
                }

                function isSigWeb_1_7_0_0_Installed(sigWebVer) {
                    var minSigWebVersionGetDaysUntilCertificateExpiresSupport = "1.7.0.0";

                    if (isOlderSigWebVersionInstalled(minSigWebVersionGetDaysUntilCertificateExpiresSupport, sigWebVer)) {
                        console.log("SigWeb version 1.7.0.0 or higher not installed.");
                        return false;
                    }
                    return true;
                }

                function isOlderSigWebVersionInstalled(cmprVer, sigWebVer) {
                    return isOlderVersion(cmprVer, sigWebVer);
                }

                function isOlderVersion(oldVer, newVer) {
                    const oldParts = oldVer.split('.')
                    const newParts = newVer.split('.')
                    for (var i = 0; i < newParts.length; i++) {
                        const a = parseInt(newParts[i]) || 0
                        const b = parseInt(oldParts[i]) || 0
                        if (a < b) return true
                        if (a > b) return false
                    }
                    return false;
                }

                function changeCanvasSize(width, height) {
                    canvas.width = width;
                    canvas.height = height;
                }


                function CursorSign(xDisplay, yDisplay) {
                    changeCanvasSize(xDisplay, yDisplay)
                    var canvas = document.getElementById("mycanvas");
                    var ctx = canvas.getContext("2d");

                    var isDrawing = false;
                    var lastX, lastY;

                    ctx.strokeStyle = "#000000";
                    ctx.lineWidth = 2;

                    canvas.addEventListener("mousedown", startDrawing);
                    canvas.addEventListener("mousemove", draw);
                    canvas.addEventListener("mouseup", stopDrawing);

                    function startDrawing(e) {
                        isDrawing = true;
                        lastX = e.offsetX;
                        lastY = e.offsetY;
                    }

                    function draw(e) {
                        if (!isDrawing) return;
                        var x = e.offsetX;
                        var y = e.offsetY;
                        ctx.beginPath();
                        ctx.moveTo(lastX, lastY);
                        ctx.lineTo(x, y);
                        ctx.stroke();
                        lastX = x;
                        lastY = y;
                    }

                    function stopDrawing() {
                        isDrawing = false;
                        var imageData = canvas.toDataURL();
                        var base64Data = imageData.replace(/^data:image\/(png|jpeg);base64,/, '');
                        document.getElementById('<%= HiddenField1.ClientID %>').value = base64Data;
                    }
                }

                function onSign(xDisplay, yDisplay) {
                    var canvas = document.getElementById("mycanvas");
                    var ctx = canvas.getContext("2d");
                    alert("Tableta");


                    if (IsSigWebInstalled()) {
                        alert("sigweb esta instalado");
                        var ctx = canvas.getContext('2d');
                        changeCanvasSize(xDisplay, yDisplay);


                        SetDisplayXSize(xDisplay);
                        SetDisplayYSize(yDisplay);
                        SetTabletState(0, tmr);
                        SetJustifyMode(0);
                        ClearTablet();

                        if (tmr == null) {
                            tmr = SetTabletState(1, ctx, 50);
                        }
                        else {
                            SetTabletState(0, tmr);
                            tmr = null;
                            tmr = SetTabletState(1, ctx, 50);
                        }

                    } else {
                        alert("Unable to communicate with SigWeb. Please confirm that SigWeb is installed and running on this PC.");
                    }

                }

                function Done()
                {
                    if (NumberOfTabletPoints() == 0) {
                        alert("Firma Antes de Continuar");
                    }
                    else {
                        //alert("done called");

                        SetTabletState(0, tmr);
                        //RETURN BMP BYTE ARRAY CONVERTED TO BASE64 STRING
                        SetImageXSize(500);
                        SetImageYSize(100);
                        SetImagePenWidth(5);
                        GetSigImageB64(SigImageCallback);
                    }
                }

                function SigImageCallback(str) {
                    //alert("sigimagecallback");
           

                    document.getElementById('<%= HiddenField1.ClientID %>').value = str;
                    //alert("added to hidden field");

                }


                function endDemo() {
                    ClearTablet();
                    SetTabletState(0, tmr);
                }

                function close() {
                    if (resetIsSupported) {
                        Reset();
                    } else {
                        endDemo();
                    }
                }

                //Perform the following actions on
                //	1. Browser Closure
                //	2. Tab Closure
                //	3. Tab Refresh
                window.onbeforeunload = function (evt) {
                    close();
                    clearInterval(tmr);
                    evt.preventDefault(); //For Firefox, needed for browser closure
                };

            </script>



            <asp:Button ID="BtnClear" runat="server" Text="Clear" OnClick="BtnClear_Click" />
            <asp:Button ID="OK_Btn" runat="server" Text="OK" OnClientClick="Done();return false;" />
            <asp:Button ID="Save_btn" runat="server" OnClick="Btn_Save_Click" Text="Save" />
       </div>                
       
        </form>

   
        
</body>
</html>
