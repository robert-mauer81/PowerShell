## Used Bing to search a method of creating a GUI with mulpiputle inputs to create a variable value.  Plan to use this in another script

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
    $button.Location = New-Object Drawing.Point(40, 100)
    $button.Text = "OK"
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
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(150,100)
    $cancelButton.Size = New-Object System.Drawing.Size(75,23)
    $cancelButton.Text = 'Cancel'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)


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