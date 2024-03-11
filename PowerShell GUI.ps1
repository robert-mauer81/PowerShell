# Load the Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# Create a function to display the input form
function Show-InputForm {
    $form = New-Object Windows.Forms.Form
    $form.Text = "Input Form"
    $form.Width = 300
    $form.Height = 200

    # Create labels and textboxes
    $label1 = New-Object Windows.Forms.Label
    $label1.Text = "Demographics:"
    $label1.Location = New-Object Drawing.Point(10, 20)
    $form.Controls.Add($label1)

    $textbox1 = New-Object Windows.Forms.TextBox
    $textbox1.Location = New-Object Drawing.Point(120, 20)
    $form.Controls.Add($textbox1)

    $label2 = New-Object Windows.Forms.Label
    $label2.Text = "OtherStuff:"
    $label2.Location = New-Object Drawing.Point(10, 60)
    $form.Controls.Add($label2)

    $textbox2 = New-Object Windows.Forms.TextBox
    $textbox2.Location = New-Object Drawing.Point(120, 60)
    $form.Controls.Add($textbox2)

    # Create an OK button
    $button = New-Object Windows.Forms.Button
    $button.Text = "OK"
    $button.Location = New-Object Drawing.Point(120, 100)
    $button.Add_Click({
        $result = [PSCustomObject]@{
            Demographics = $textbox1.Text
            OtherStuff = $textbox2.Text
        }
        $form.Close()
        $result
    })
    $form.Controls.Add($button)
    
    # Create an Cancel button 


    # Show the form
    $form.ShowDialog()
}

# Call the function and store the result
$result = Show-InputForm

# Access the input values
$demographics = $result.Demographics
$otherStuff = $result.OtherStuff

# Now you can use these variables in your script
Write-Host "Demographics: $demographics"
Write-Host "OtherStuff: $otherStuff"