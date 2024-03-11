## Used Bing to search a method of creating a GUI with mulpiputle inputs to create a variable value.  Plan to use this in another script

# Load the Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# Create a function to display the input form
function Show-InputForm {
    $form = New-Object Windows.Forms.Form
    $form.Text = "New ADUser Form"
    $form.Width = 300
    $form.Height = 300

    # Create labels and textboxes

    #Label 1 "First Name" to input the variable for the first name
    $label1 = New-Object Windows.Forms.Label
    $label1.Text = "First Name:"
    $label1.Location = New-Object Drawing.Point(10, 20)
    $form.Controls.Add($label1)

    $textbox1 = New-Object Windows.Forms.TextBox
    $textbox1.Location = New-Object Drawing.Point(120, 20)
    $form.Controls.Add($textbox1)

    #Label 2 "Last Name" to input the variable for the Last name 
    $label2 = New-Object Windows.Forms.Label
    $label2.Text = "Last Name:"
    $label2.Location = New-Object Drawing.Point(10, 60)
    $form.Controls.Add($label2)

    $textbox2 = New-Object Windows.Forms.TextBox
    $textbox2.Location = New-Object Drawing.Point(120, 60)
    $form.Controls.Add($textbox2)

    #Label 3 "Email Address" to input the variable for the Last name 
    $label3 = New-Object Windows.Forms.Label
    $label3.Text = "Email Address:"
    $label3.Location = New-Object Drawing.Point(10, 100)
    $form.Controls.Add($label3)
    
    $textbox3 = New-Object Windows.Forms.TextBox
    $textbox3.Location = New-Object Drawing.Point(120, 100)
    $form.Controls.Add($textbox3)

    # Create an OK button
    $button = New-Object Windows.Forms.Button
    $button.Location = New-Object Drawing.Point(40, 200)
    $button.Text = "OK"
      $button.Add_Click({
        $result = [PSCustomObject]@{
            FirstName = $textbox1.Text
            LastName = $textbox2.Text
            Email = $textbox3.Text
        }
        $form.Close()
        $result
    })
    $form.Controls.Add($button)
 
    # Create an Cancel button 
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(150,200)
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
$FirstName = $result.FirstName
$LastName = $result.LastName
$Email = $result.Email

# Now you can use these variables in your script
Write-Host "Fiirst Name: $FirstName"
Write-Host "Last Name: $LastName"
Write-Host "Email Address: $Email"