=put
package Intern::Diary::Config::Route;

use strict;
use warnings;
use utf8;

use Intern::Diary::Config::Route::Declare;

sub make_router {
    return router {
        connect '/' => {
            engine => 'Index',
            action => 'default',
        };

        connect '/diary' => {
            engine => 'Diary',
            action => 'default',
        };

        connect '/diary/add' => {
            engine => 'Diary',
            action => 'add_get',
        } => { method => 'GET' };
        connect '/diary/add' => {
            engine => 'Diary',
            action => 'add_post',
        } => { method => 'POST' };

        connect '/diary/delete' => {
            engine => 'Diary',
            action => 'delete_get',
        } => { method => 'GET' };
        connect '/diary/delete' => {
            engine => 'Diary',
            action => 'delete_post',
        } => { method => 'POST' };

        # API
        connect '/api/diaries' => {
            engine => 'API',
            action => 'diaries',
        };
        connect '/api/diary' => {
            engine => 'API',
            action => 'diary_post',
        } => { method => 'POST'};
    };
}

1;
=cut