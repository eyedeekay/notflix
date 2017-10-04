
var input = document.getElementById('input');

input.onkeyup = function () {
    var filter = input.value.toUpperCase();
    var lis = document.getElementsByTagName('li');
    for (var i = 0; i < lis.length; i++) {
        var name = lis[i].getElementsByTagName('a');
        var genre = lis[i].getElementsByTagName('li');
        if (typeof name != 'undefined')
            if (typeof name[0] != 'undefined')
                if (name[0].innerHTML.toUpperCase().indexOf(filter) != -1)
                    lis[i].style.display = 'list-item';
                else
                    lis[i].style.display = 'none';
        if (typeof genre != 'undefined')
            if (typeof genre[1] != 'undefined')
                if (genre[1].innerHTML.toUpperCase().indexOf(filter) != -1)
                    lis[i].style.display = 'list-item';
                else
                    lis[i].style.display = 'none';
    }
}
