// Modified to transition from one value to another and then stop.

(function($) {

    $.fn.dynamo = function() {

        return this.each(function(i, v) {
            v = $(v);
            delay = parseInt(v.data('delay')) || 3000;
            speed = parseInt(v.data('speed')) || 350;
            pause = v.data('pause') || false;
            lines = v.data('lines');

            // wrap the original contents in a span
            v.html($('<span></span>').text(v.text()));

            // grab the width of the span
            max = v.find('span:eq(0)').width();

            // for each item in data-lines, create a span with item as its content
            // compare the width of this span with the max
//            for (k in lines) {
                span = $('<span></span>').text(lines);
                v.append(span);
                max = Math.max(max, span.width());
//            }

            // replace all the spans with inline-div's
            v.find('span').each(function(i, ele) {
                s = $(ele).remove();
                d = $('<div></div>').text(s.text());
                d.width(max);
                v.append(d);
            });

            // set the height of the dynamo container
            height = v.find('>:first-child').height();

            // style
            v.width(max)
             .height(height)
             .css({
                 'display' : 'inline-block',
                 'position' : 'relative',
                 'overflow' : 'hidden',
                 'vertical-align' : 'bottom',
                 'text-align' : 'left'
             });

            // manually center it if we need to
            if (v.data('center'))
                v.css('text-align', 'center');

            // now, animate it
            transition = function() {
                v.find('div:first').slideUp(speed, function() { 
                    v.append($(this).show());
                });
            };

            transition();

//            if (!pause) {
//              setInterval(transition, delay);
//            }
        });
    };

    // automatically initiate cycles on elements of class 'dynamo'
    $('.dynamo').dynamo();

})(jQuery);