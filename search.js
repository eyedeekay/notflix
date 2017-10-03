
var input = document.getElementById('input');

input.onkeyup = function () {
    var filter = input.value.toUpperCase();
    var lis = document.getElementsByTagName('li');
    for (var i = 0; i < lis.length; i++) {
        var name = lis[i].getElementsByTagName('a');
        if (typeof name != 'undefined'){
            if (typeof name[0] != 'undefined')
                if (name[0].innerHTML.toUpperCase().indexOf(filter) == 0)
                    lis[i].style.display = 'list-item';
                else
                    lis[i].style.display = 'none';
        }
    }
}
