$(document).ready(function(){        
    $('#addUser, .editUser').click(function(){
        $('#userModal').modal({
            backdrop: 'static',
            keyboard: false
        });

        $("#userModal").on("shown.bs.modal", function (event) {
            var button = $(event.relatedTarget);
            var userId = button.data('userid');
            if (userId) {
                userId = parseInt(userId); // Ensure it's a valid integer
                $('#userid').val(userId);
                $('.modal-title').html("<i class='fa fa-pencil'></i> Edit User");
                $('#action').val('updateUser');
                $('#save').val('Update');
            } else {
                $('#userForm')[0].reset();
                $('.modal-title').html("<i class='fa fa-plus'></i> Add User");
                $('#action').val('addUser');
                $('#save').val('Save');
            }
        });
    });
});
