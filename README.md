# BarCamp Tampa App #

## The MIT License ##

Copyright (c) 2010 Barry Ezell

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Description ##

iPhone app designed to retrieve schedule information for BarCamp TampaBay 2010 and allow users to bookmark talks they wish to attend.  

## Note Regarding Non-Open Source Images ##

Several images used in the app are not open sourced and have not been included in the git repository.  The app will not look or work correctly until the correct or substitue images are added to the project. 

Four commercial icons removed are: forward.png, back.png, money.png, calendar.png
They may be purchased as a set from: http://eddit.com/shop/iphone_ui_icon_set/

Textured background for TalkViewController was purchased from: http://graphicriver.net/item/linen-2o/123044

## Implementation Notes ##

The app works with a web service that can respond to two RESTful requests and return json.  

http://yourwebsvc.org/talks.json which returns json of this form:

	{ "talks": [{"talk":{"room_id":1,"name":"Learning Objective-C","room_name":"DISYS Room","end_time":"2000-01-01T09:00:00Z","created_at":"2010-09-16T00:37:02Z","updated_at":"2010-09-16T02:16:50Z","deleted_at":"2010-09-16T02:54:45Z","id":37,"day":"2010-09-25","who":"John Dough","start_time":"2000-01-01T08:00:00Z"}} ] }


http://yourwebsvc.org/sponsors.json which returns json of this form:

	{ "sponsors": [{"sponsor":{"name":"McDougal's","id":1,"homepage":"http://www.mcdougals.com"}} ] }

Currently the app requires the dates of the BarCamp to be written to the Days.plist file.  It could be refactored to get the days from the web service and thus not require a yearly update.

