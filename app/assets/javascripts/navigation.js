var defaultSection = 'wishlist';

$(function() {
    $('nav li a').bind('click', function(event) {
        changeToSection($(this).attr('href').substring(1));
    });
    $('section').each(function (index, element) {
        element.id = 'container-' + element.id;
    });
    changeToHashSection();
});

function changeToHashSection() {
    var curSection = self.document.location.hash;
    if (curSection === '' || curSection == '#' || typeof curSection == 'undefined') {
        curSection = defaultSection;
    } else {
        var found = false;
        curSection = curSection.substring(1);
        $('section').each(function(num, ele) {
            if (ele.id === curSection) {
                found = true;
                return;
            }
        });

        if (!found)
            curSection = defaultSection;
    }

    changeToSection(curSection);
}

function changeToSection(section) {
    $('section').addClass('invisible');
    $('section#container-' + section).removeClass('invisible');
    // console.log('change to section: ' + section);
    $('nav li a').removeClass('active');
    $('nav li a[href=#' + section + ']').addClass('active');

    if (window.Piwik) {
        var p = Piwik.getTracker();
        p.discardHashTag(false);
        p.trackPageView(section);
    }
}
