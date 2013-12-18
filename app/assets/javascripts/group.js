var OSCURRENCY = {};

// indexOf for IE http://bit.ly/haIWRa
[].indexOf || (Array.prototype.indexOf = function(v,n){
  n = (n==null) ? 0 : n; 
  var m = this.length;
  for(var i = n; i < m; i++)
    if(this[i] == v)
       return i;
  return -1;
});

$(function() {

  OSCURRENCY.group_id = find_group();
  OSCURRENCY.routes = [];
  OSCURRENCY.tab_prefix = '#tab_';
  OSCURRENCY.tab = '';
  OSCURRENCY.post_allowed = true;
  OSCURRENCY.notice_fadeout_time = 8000;
  OSCURRENCY.delete_fadeout_time = 4000;
  OSCURRENCY.offers_mode = '';
  OSCURRENCY.reqs_mode = '';
  OSCURRENCY.searchable_tabs = ['#people','#memberships','#reqs','#requests','#offers', '#messages'];
  OSCURRENCY.no_filter_option = 1;
  OSCURRENCY.categories_filter_option = 2;
  OSCURRENCY.neighborhoods_filter_option = 3;

  route('home',     /^#home$/,                                     '/groups/[:group_id]');
  route('home',     /^#member_preferences\/(\d+)\/edit$/,          '/member_preferences/[:1]/edit');

  route('exchanges',/^#exchanges\/page=(\d+)/,                     '/groups/[:group_id]/exchanges?page=[:1]');
  route('requests', /^#reqs\/page=(\d+)\/search=(.+)/,             '/groups/[:group_id]/reqs?page=[:1]&search=[:2]');
  route('requests', /^#reqs\/page=(\d+)/,                          '/groups/[:group_id]/reqs?page=[:1]');
  route('requests', /^#reqs\/search=(.+)/,                         '/groups/[:group_id]/reqs?search=[:1]');
  route('requests', /^#requests\/search=(.+)/,                     '/groups/[:group_id]/reqs?search=[:1]');
  route('offers',   /^#offers\/page=(\d+)\/search=(.+)/,           '/groups/[:group_id]/offers?page=[:1]&search=[:2]');
  route('offers',   /^#offers\/page=(\d+)/,                        '/groups/[:group_id]/offers?page=[:1]');
  route('offers',   /^#offers\/search=(.+)/,                       '/groups/[:group_id]/offers?search=[:1]');
  route('people',   /^#people\/page=(\d+)\/search=(.+)/,           '/groups/[:group_id]/memberships?page=[:1]&search=[:2]');
  route('people',   /^#people\/page=(\d+)/,                        '/groups/[:group_id]/memberships?page=[:1]');
  route('people',   /^#people\/search=(.+)/,                       '/groups/[:group_id]/memberships?search=[:1]');
  route('people',   /^#memberships\/search=(.+)/,                  '/groups/[:group_id]/memberships?search=[:1]');
  route('forum',    /^#forum\/page=(\d+)/,                         '/groups/[:group_id]/forum?page=[:1]');

  route('requests', /^#reqs\/(\d+)$/,                              '/reqs/[:1]');
  route('requests', /^#reqs\/(\d+)\/edit$/,                        '/reqs/[:1]/edit');
  route('requests', /^#reqs\/new$/,                                '/groups/[:group_id]/reqs/new');
  route('offers',   /^#offers\/(\d+)$/,                            '/offers/[:1]');
  route('offers',   /^#offers\/(\d+)\/edit$/,                      '/offers/[:1]/edit');
  route('offers',   /^#offers\/new$/,                              '/groups/[:group_id]/offers/new');

  route('people',   /^#people\/(.+)\/exchanges\/new$/,             '/people/[:1]/exchanges/new?group='+OSCURRENCY.group_id);
  route('people',/^#people\/(.+)\/exchanges\/new\/customer=(\d+)$/,'/people/[:1]/exchanges/new?group='+OSCURRENCY.group_id+'&customer=[:2]');
  route('offers',   /^#people\/(.+)\/exchanges\/new\/offer=(\d+)$/,'/people/[:1]/exchanges/new?offer=[:2]');
  route('people',   /^#people\/(.+)\/messages\/new$/,              '/people/[:1]/messages/new');
  route('people',   /^#people\/(.+)\/accounts\/(\d+)/,             '/people/[:1]/accounts/[:2]');

  route('people',   /^#memberships\/(\d+)$/,                       '/memberships/[:1]');
  route('forum',    /^#forums\/(\d+)\/topics\/(\d+)$/,             '/forums/[:1]/topics/[:2]');
  route('forum',    /^#forums\/(\d+)\/topics\/(\d+)\/page=(\d+)$/, '/forums/[:1]/topics/[:2]?page=[:3]');
  route('exchanges',/^#exchanges$/,                                '/groups/[:group_id]/exchanges');
  route('forum',    /^#forum$/,                                    '/groups/[:group_id]/forum');

  // request hashes are inconsistent since controller is reqs
  route('requests', /^#requests$/,                                 '/groups/[:group_id]/reqs');
  route('requests', /^#requests\/category_id=$/,                   '/groups/[:group_id]/reqs');
  route('requests', /^#requests\/category_id=(\d+)$/,              '/groups/[:group_id]/reqs?category_id=[:1]');
  route('requests', /^#reqs\/category_id=(\d+)\/page=(\d+)$/,      '/groups/[:group_id]/reqs?category_id=[:1]&page=[:2]');
  route('requests', /^#requests\/neighborhood_id=$/,              '/groups/[:group_id]/reqs');
  route('requests', /^#requests\/neighborhood_id=(\d+)$/,          '/groups/[:group_id]/reqs?neighborhood_id=[:1]');
  route('requests', /^#reqs\/neighborhood_id=(\d+)\/page=(\d+)$/,  '/groups/[:group_id]/reqs?neighborhood_id=[:1]&page=[:2]');

  route('offers',   /^#offers$/,                                   '/groups/[:group_id]/offers');
  route('offers',   /^#offers\/category_id=$/,                     '/groups/[:group_id]/offers');
  route('offers',   /^#offers\/category_id=(\d+)$/,                '/groups/[:group_id]/offers?category_id=[:1]');
  route('offers',   /^#offers\/category_id=(\d+)\/page=(\d+)$/,    '/groups/[:group_id]/offers?category_id=[:1]&page=[:2]');
  route('offers',   /^#offers\/neighborhood_id=$/,                 '/groups/[:group_id]/offers');
  route('offers',   /^#offers\/neighborhood_id=(\d+)$/,            '/groups/[:group_id]/offers?neighborhood_id=[:1]');
  route('offers',   /^#offers\/neighborhood_id=(\d+)\/page=(\d+)$/,'/groups/[:group_id]/offers?neighborhood_id=[:1]&page=[:2]');

  route('people',   /^#people$/,                                   '/groups/[:group_id]/memberships');
  route('people',   /^#people\/category_id=$/,                     '/groups/[:group_id]/memberships');
  route('people',   /^#people\/category_id=(\d+)$/,                '/groups/[:group_id]/memberships?category_id=[:1]');
  route('people',   /^#people\/category_id=(\d+)\/page=(\d+)$/,    '/groups/[:group_id]/memberships?category_id=[:1]&page=[:2]');
  route('people',   /^#people\/neighborhood_id=$/,                 '/groups/[:group_id]/memberships');
  route('people',   /^#people\/neighborhood_id=(\d+)$/,            '/groups/[:group_id]/memberships?neighborhood_id=[:1]');
  route('people',   /^#people\/neighborhood_id=(\d+)\/page=(\d+)$/,'/groups/[:group_id]/memberships?neighborhood_id=[:1]&page=[:2]');

  route('messages', /^#messages$/,                                  '/messages');
  route('messages', /^#messages\/page=(\d+)$/,                      '/messages?page=[:1]');
  route('messages', /^#messages\/(\d+)$/,                           '/messages/[:1]');
  route('messages', /^#messages\/new$/,                             '/messages/new');
  route('messages', /^#messages\/trash$/,                           '/messages/trash');
  route('messages', /^#messages\/sent$/,                            '/messages/sent');
  route('messages', /^#messages\/trash\/page=(\d+)$/,               '/messages/trash?page=[:1]');
  route('messages', /^#messages\/sent\/page=(\d+)$/,                '/messages/sent?page=[:1]');
  route('messages', /^#messages\/(\d+)\/edit$/,                     '/messages/[:1]/edit');
  route('messages', /^#messages\/(\d+)\/reply$/,                    '/messages/[:1]/reply');
  route('messages', /^#messages\/(\d+)\/undestroy$/,                '/messages/[:1]/undestroy');

  function find_group() {
    path = window.location.pathname;
    a = path.split('/');
    return a[2];
  }

  function route(tab,path,url) {
    r = {'tab':OSCURRENCY.tab_prefix+tab,'path':path,'url':url};
    OSCURRENCY.routes.push(r);
  }

  function resolve(path) {
    var a = [];
    var url = '';
    var tab = '';
    for(i=0;i<OSCURRENCY.routes.length;i++) {
      r = OSCURRENCY.routes[i];
      if(a = path.match(r['path'])) {
        tab = r['tab'];
        url = r['url'].replace(/\[:group_id\]/,OSCURRENCY.group_id);
        for(j=1;j<a.length;j++) {
          url = url.replace('[:'+j+']',a[j]);
        }
        return [tab,url];
      }
    }
    return ['',''];
  }

  function parse_url(url) {
    // regular expression for url parsing from Douglas Crockford
    var parse_url = /^(?:([A-Za-z]+):)?(\/{0,3})([0-9.\-A-Za-z]+)(?::(\d+))?(?:\/([^?#]*))?(?:\?([^#]*))?(?:#(.*))?$/;
    return parse_url.exec(url);
  }

  function url2hash(url) {
    names = ['url', 'scheme', 'slash', 'host', 'port','path', 'query', 'hash'];
    result = parse_url(url);
    path = result[names.indexOf('path')]
    query = result[names.indexOf('query')]

    hash = '#';
    a = path.split('/');
    for(i=0;i<parseInt(a.length/2);i++) {
      if(i>0 && (hash.length > 1)) {
        hash += '/';
      }
      if(a[i*2] != 'groups') {
        hash += a[i*2] + '/' + a[i*2+1];
      }
    }
    if(parseInt(a.length/2) != a.length/2) {
      if(hash.length > 1) {
        hash += '/';
      }
      hash += a[a.length - 1];
    }
    if(query != undefined) {
      if(query.length > 0) {
        var params = query.split('&');
        for(i=0;i<params.length;i++) {
          if(params[i].split('=')[0] != 'group') {
            hash += '/' + params[i];
          }
        }
      }
    }
    return hash;
  }

  function active_option(mode,url) {
    var response = ""
    if('all' == mode) {
      if((-1==url.indexOf('edit')) && (-1==url.indexOf('new'))) {
        response = (-1==url.indexOf('?')) ? "?scope=all" : "&scope=all";
      }
    }
    return response;
  }

  $(window).hashchange( function() {
      var hash = location.hash;
      var js_url = "";
      var tab = "";
      var a = [];
      if(hash.length != 0) {
        a = resolve(hash);
        tab = a[0];
        js_url = a[1];
        if('#tab_offers' == tab) {
          js_url += active_option(OSCURRENCY.offers_mode,js_url);
        } else if('#tab_requests' == tab) {
          js_url += active_option(OSCURRENCY.reqs_mode,js_url);
        }

        if(tab != OSCURRENCY.tab) {
          $('#nav-js a[href="'+tab+'"]').tab('show');
          OSCURRENCY.tab=tab;
          var current_filter = window.location.hash.split('/')[0] + '_filter'; 
          $(current_filter + ' span.neighborhood_filter').hide();
          $(current_filter + ' span.category_filter').hide();
          $('#filter_reqs_by').val(OSCURRENCY.no_filter_option);
          $('#filter_offers_by').val(OSCURRENCY.no_filter_option);
          $('#filter_memberships_by').val(OSCURRENCY.no_filter_option);
        }
        if(js_url.length != 0) {
          $.ajaxSetup({cache:true});
          $.getScript(js_url);
          $.ajaxSetup({cache:false});
        }
      }
    });

  $(document).bind('ajaxStart', function() {
      $('span.wait').show();
    });

  $(document).bind('ajaxStop', function() { 
      $('span.wait').hide();
      OSCURRENCY.post_allowed = true;
    });

  $("input#bid_expiration_date").live('focus', function() {
    $(this).datepicker({
      buttonImage: "/images/calendar.gif",
      buttonImageOnly: true,
      dateFormat: "yy-mm-dd"
      });
    });

  $("input#req_due_date").live('focus', function() {
    $(this).datepicker({
      buttonImage: "/images/calendar.gif",
      buttonImageOnly: true,
      dateFormat: "yy-mm-dd"
      });
    });

  $("input#offer_expiration_date").live('focus', function() {
    $(this).datepicker({
      buttonImage: "/images/calendar.gif",
      buttonImageOnly: true,
      dateFormat: "yy-mm-dd"
      });
    });

  $('.edit_member_preference, #new_bid, .edit_bid, #new_req, #edit_req,  #new_topic, #new_post, #new_exchange, #new_wall_post, #tabs #new_message').live('submit',function() {
      if(OSCURRENCY.post_allowed) {
        OSCURRENCY.post_allowed = false;
        $.post($(this).attr('action'),$(this).serialize(),null,'script');
      } else {
        alert('request is being processed...');
      }
      return false;
    });

  $('.search_form').live('submit',function() {
      current_tab = window.location.hash.split('/')[0];
      if(-1 == OSCURRENCY.searchable_tabs.indexOf(current_tab)) {
        var frags = window.location.pathname.split('/');
        if ('groups' == frags[1] && 'members' ==  frags[3]) {
          window.location = '/groups/' + OSCURRENCY.group_id + '/members?search=' + $(this).children('input').attr('value');
          return false;
        } else if ('messages' == frags[1]) {
          window.location = '/messages?search=' + $(this).children('input').attr('value');
          return false;
        }
        alert('tab '+current_tab+' is not supported for search');
      } else {
        window.location.hash = current_tab + '/' + $(this).serialize();
      }
      return false;
    });

  $('.add_to_memberships').live('click', function() {
      if(confirm('Are you sure?'))
      {
        id_name = $(this).children('a').attr('id');
        $(this).hide();
        var data = (id_name == 'leave_group') ? {'_method': 'delete'} : {};
        $.post($(this).children('a').attr('href'),data,null,'script');
      }
      return false;
    });

  $('.delete_topic, .delete_post, .delete_req, .delete_offer, .delete_bid').live('click', function() {
      if(confirm('Delete?'))
      {
        var data = {'_method': 'delete'}
        $.post($(this).attr('href'),data,null,'script');
      }
      return false;
    });

  $('.deactivate_req').live('click', function() {
    var data = {'_method': 'deactivate'}
    $.post($(this).attr('href'),data,null,'script');
    return false;
  });

  $('.per_page').live('click', function() {
    var number_clicked = $(this).attr('data-ppp');
    var data = {'_method': 'put', 'person': {'posts_per_page': number_clicked}}
    $('.per_page').removeClass('btn btn-small btn-primary');
    $(this).addClass('btn btn-small btn-primary');
    $.post($(this).attr('href'),data,null,'script');
    return false;
  });

  $('a.pay_now').live('click', function() {
    window.location.hash = url2hash(this.href);
    return false;
    });

  $('body.groups .pagination a').live('click',function() {
    str = url2hash(this.href);
    // XXX hack until hash is renamed to match
    str = str.replace(/memberships/,'people');
    window.location.hash = str;
    return false;
    });

  $('a[href=' + OSCURRENCY.tab_prefix + 'home]').bind('click',function () {
      window.location.hash = '#home';
    });

  $('a[href=' + OSCURRENCY.tab_prefix + 'forum]').bind('click',function() {
    $('#forum_form').html('');
    window.location.hash = '#forum';
    });

  $('a[href=' + OSCURRENCY.tab_prefix + 'requests]').bind('click',function() {
      window.location.hash = '#requests';
    });

  $('a[href=' + OSCURRENCY.tab_prefix + 'offers]').bind('click',function() {
      window.location.hash = '#offers';
    });

  $('a[href=' + OSCURRENCY.tab_prefix + 'exchanges]').bind('click',function() {
      window.location.hash = '#exchanges';
    });

  $('a[href=' + OSCURRENCY.tab_prefix + 'people]').bind('click',function() {
      window.location.hash = '#people';
    });

  $('a[href=' + OSCURRENCY.tab_prefix + 'messages]').bind('click',function() {
      window.location.hash = '#messages';
    });

  $('.category_filter #req_category_ids').live('change',function() {
    window.location.hash = '#requests/category_id=' + this.value;
    });

  $('.category_filter #offer_category_ids').live('change',function() {
    window.location.hash = '#offers/category_id=' + this.value;
    });

  $('.category_filter #person_category_ids').live('change',function() {
    window.location.hash = '#people/category_id=' + this.value;
    });


  $('.neighborhood_filter #req_neighborhood_ids').live('change',function() {
    window.location.hash = '#requests/neighborhood_id=' + this.value;
    });

  $('.neighborhood_filter #offer_neighborhood_ids').live('change',function() {
    window.location.hash = '#offers/neighborhood_id=' + this.value;
    });

  $('.neighborhood_filter #person_neighborhood_ids').live('change',function() {
    window.location.hash = '#people/neighborhood_id=' + this.value;
    });

  $('#filter_reqs_by, #filter_offers_by, #filter_memberships_by').live('change',function() {
    var current_hash_root = window.location.hash.split('/')[0]; 
    var current_filter = current_hash_root + '_filter';
    if(OSCURRENCY.categories_filter_option == this.value) {
      $(current_filter + ' span.category_filter').show();
      $(current_filter + ' span.neighborhood_filter').hide();
    } else if (OSCURRENCY.neighborhoods_filter_option == this.value) {
      $(current_filter + ' span.category_filter').hide();
      $(current_filter + ' span.neighborhood_filter').show();
    } else {
      $(current_filter + ' span.neighborhood_filter').hide();
      $(current_filter + ' span.category_filter').hide();
      window.location.hash = current_hash_root;
    }
    });

  $('a.show-follow').live('click',function() {
    window.location.hash = url2hash(this.href);
    return false;
    });

  $('a.email-link:not(.noajax)').live('click',function() {
    window.location.hash = url2hash(this.href);
    return false;
    });

  function change_offers_mode(mode) {
    if(mode != OSCURRENCY.offers_mode) {
      OSCURRENCY.offers_mode = mode;
      if('#offers' == window.location.hash) {
        // force a hash change
        window.location.hash = '#offers/page=1';
      } else {
        window.location.hash = '#offers';
      }
    }
  }

  function change_reqs_mode(mode) {
    if(mode != OSCURRENCY.reqs_mode) {
      OSCURRENCY.reqs_mode = mode;
      if('#requests' == window.location.hash) {
        // force a hash change
        window.location.hash = '#reqs/page=1';
      } else {
        window.location.hash = '#requests';
      }
    }
  }

  $(window).trigger('hashchange');
});

function update_topic() {
  topic_id = $('#topic').attr('data-id');
  after = $('.forum_post:first-child').attr('data-time');
  $.ajaxSetup({cache:true});
  $.getScript('/posts?topic_id=' + topic_id + '&after=' + after);
  $.ajaxSetup({cache:false});
}

