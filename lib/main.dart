import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid 19 Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        fontFamily: 'Roboto'
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
   List<Country> countries =[];
   bool _isLoading = true;
   Country mzansi = Country();
   Country global = Country();

  getData() async {
    try {
      var getCountriesReponse = await get('https://api.covid19api.com/summary');
    var countriesData = await jsonDecode(getCountriesReponse.body);
    print(countriesData);
    global.countryName = 'South Africa';
    global.totalConfirmed = countriesData['Global']['TotalConfirmed'];
    global.totalRecovered = countriesData['Global']['TotalRecovered'];
    global.date =  countriesData['Global']['Date'];
    global.totalDeaths = countriesData['Global']['TotalDeaths'];

    await countriesData['Countries'].forEach((country) {
      
      if (country['Country'] == 'South Africa') {
        mzansi.countryName = 'South Africa';
        mzansi.totalConfirmed = country['TotalConfirmed'];
        mzansi.totalRecovered = country['TotalRecovered'];
        mzansi.date =  country['Date'];
        mzansi.totalDeaths = country['TotalDeaths'];
      }
      
      countries.add(Country (
        countryName: country['Country'],
        date: country['Date'],
        totalConfirmed: country['TotalConfirmed'],
        totalDeaths: country['TotalDeaths'],
        totalRecovered: country['TotalRecovered']
      ));
    });
    

    print(countries);
    
    setState(() {
      _isLoading = false;
    });
    } catch (e) {
      print(e);
    }
    
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: _isLoading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Container(
        child: Column(
           children: <Widget>[
             ClipPath(
               clipper: MyClipper(),
               child: Container(
               height: 300,
               width: double.infinity,
               decoration: BoxDecoration(
                 gradient: LinearGradient(
                   begin: Alignment.topRight,
                   end: Alignment.bottomLeft,
                   colors: [
                   Color(0xFF3383CD),
                   Color(0xFF11249F)
                 ],
                 ),
                 image: DecorationImage(image: AssetImage('assets/virus.png'))
               ),
               child: Column(
                 children: <Widget>[
                   Expanded(child: Stack(
                     children: <Widget>[
                       SvgPicture.asset('assets/doctor.svg',
                       fit: BoxFit.fill,
                       alignment: Alignment.topCenter),
                       Container(
                         padding: EdgeInsets.all(16.0),
                         width: double.infinity,
                         height: 300,
                         color: Colors.black38,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             SizedBox(height: 30),
                             Text("Covid-19 Tracker",
                             textAlign: TextAlign.left,
                             style: TextStyle(
                               fontSize: 18.0,
                               color: Colors.white,
                               fontFamily: 'Roboto'
                             )),
                             SizedBox(height: 45),
                             Text("South Africa",
                             textAlign: TextAlign.left,
                             style: TextStyle(
                               fontSize: 40.0,
                               fontWeight: FontWeight.bold,
                               color: Colors.white,
                             )),
                             SizedBox(height: 12),
                             Text("Daily Updates",
                             textAlign: TextAlign.left,
                             style: TextStyle(
                               fontSize: 14.0,
                               color: Colors.white,
                             )),
                           ],
                         ),
                        ),
                        
                     ],
                   ))
                 ],
               )
             ),
             ),

              Container(
               margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
               alignment: Alignment.center,
               child: Column(
                 
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
                   Text("WORLDWIDE",
                   style: TextStyle(
                     fontSize: 18.0,
                     fontWeight: FontWeight.bold,
                     color: Colors.grey[700],
                     letterSpacing: 2.0,
                   ),),
                   SizedBox(height: 8.0),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                   Expanded(child: Container(
                     padding: EdgeInsets.all(16.0),
                     margin: EdgeInsets.only(right:5.0),
                     decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                      ),
                      
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                     ),
                     child: Column(children: <Widget>[
                       Text("CONFIRMED",
                       style: TextStyle(
                         color: Colors.grey[700],
                         fontWeight: FontWeight.bold,
                       )),
                       SizedBox(height: 8.0),
                       Text("${global.totalConfirmed}",
                       style: TextStyle(
                         color: Colors.yellow[800],
                         fontWeight: FontWeight.bold,
                         fontSize: 20.0
                       ))
                     ],)
                   ),),
                   Expanded(child: Container(
                     padding: EdgeInsets.all(16.0),
                     margin: EdgeInsets.only(right:5.0),
                     decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                     child: Column(children: <Widget>[
                       Text("RECOVERED",
                       style: TextStyle(
                         color: Colors.grey[700],
                         fontWeight: FontWeight.bold,
                       )),
                       SizedBox(height: 8.0),
                       Text("${global.totalRecovered}",
                       style: TextStyle(
                         color: Colors.green[700],
                         fontWeight: FontWeight.bold,
                         fontSize: 20.0
                       ))
                     ],)
                   ),),
                   Expanded(child: Container(
                     padding: EdgeInsets.all(16.0),
                     margin: EdgeInsets.only(right:8.0),
                     decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                     child: Column(children: <Widget>[
                       Text("DEATHS",
                       style: TextStyle(
                         color: Colors.grey[700],
                         fontWeight: FontWeight.bold,
                       )),
                       SizedBox(height: 8.0),
                       Text("${global.totalDeaths}",
                       style: TextStyle(
                         color: Colors.red,
                         fontWeight: FontWeight.bold,
                         fontSize: 20.0
                       ))
                     ],)
                   ))
                 ],),
               ],)
             )
             ,
             Container(
               margin: EdgeInsets.all(16.0),
               alignment: Alignment.center,
               child: Column(
                 
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
                   Text("SOUTH AFRICA",
                   style: TextStyle(
                     fontSize: 18.0,
                     fontWeight: FontWeight.bold,
                     color: Colors.grey[700],
                     letterSpacing: 2.0,
                   ),),
                   SizedBox(height: 8.0),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                   Expanded(child: Container(
                     padding: EdgeInsets.all(16.0),
                     margin: EdgeInsets.only(right:5.0),
                     decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                      ),
                      
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                     ),
                     child: Column(children: <Widget>[
                       Text("CONFIRMED",
                       style: TextStyle(
                         color: Colors.grey[700],
                         fontWeight: FontWeight.bold,
                       )),
                       SizedBox(height: 8.0),
                       Text("${mzansi.totalConfirmed}",
                       style: TextStyle(
                         color: Colors.yellow[800],
                         fontWeight: FontWeight.bold,
                         fontSize: 20.0
                       ))
                     ],)
                   ),),
                   Expanded(child: Container(
                     padding: EdgeInsets.all(16.0),
                     margin: EdgeInsets.only(right:5.0),
                     decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                     child: Column(children: <Widget>[
                       Text("RECOVERED",
                       style: TextStyle(
                         color: Colors.grey[700],
                         fontWeight: FontWeight.bold,
                       )),
                       SizedBox(height: 8.0),
                       Text("${mzansi.totalRecovered}",
                       style: TextStyle(
                         color: Colors.green[700],
                         fontWeight: FontWeight.bold,
                         fontSize: 20.0
                       ))
                     ],)
                   ),),
                   Expanded(child: Container(
                     padding: EdgeInsets.all(16.0),
                     margin: EdgeInsets.only(right:8.0),
                     decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                     child: Column(children: <Widget>[
                       Text("DEATHS",
                       style: TextStyle(
                         color: Colors.grey[700],
                         fontWeight: FontWeight.bold,
                       )),
                       SizedBox(height: 8.0),
                       Text("${mzansi.totalDeaths}",
                       style: TextStyle(
                         color: Colors.red,
                         fontWeight: FontWeight.bold,
                         fontSize: 20.0
                       ))
                     ],)
                   ))
                 ],),
               ],)
             ),
             Container(
               padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
               
               color: Colors.white,
               child: Center(child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Expanded(child: Container(child : Text("COUNTRIES", textAlign: TextAlign.start,))),
                 Expanded(child: Container(child : Text("C", textAlign: TextAlign.end, style: TextStyle( fontWeight: FontWeight.bold, color: Colors.yellow[800] ),))),
                 Expanded(child: Container(child : Text("R", textAlign: TextAlign.end, style: TextStyle( fontWeight: FontWeight.bold, color: Colors.green ),))),
                 Expanded(child: Container(child : Text("D", textAlign: TextAlign.end, style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red),)))
               ],
             ),)
             ),
             Container(
               width: double.infinity,
               color: Colors.white,
               padding: EdgeInsets.symmetric(horizontal: 16.0),
               child: ListView(
                 shrinkWrap: true,
                 physics: ClampingScrollPhysics(),
                 children: countries.map((Country country) {
                   return CountryTile(
                     confirmed: country.totalConfirmed, 
                     countryName: country.countryName,
                     deaths: country.totalDeaths, 
                     recovered: country.totalRecovered,);
                 }).toList(),
               ),
               ),
    
           ],
        ),
      ),
      ),
      bottomNavigationBar: BottomNavigationBar(
       currentIndex: 0, // this will be set when a new tab is tapped
       items: [
         BottomNavigationBarItem(
           icon: new Icon(Icons.home),
           title: new Text('Home'),
         ),
         BottomNavigationBarItem(
           icon: new Icon(Icons.info_outline),
           title: new Text('About'),
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.map),
           title: Text('Visual Map')
         )
       ],
    ),
    );
  }
}

class CountryTile extends StatelessWidget {

  CountryTile({this.countryName, this.confirmed, this.deaths, this.recovered});

  final String countryName;
  final int confirmed, recovered, deaths;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(child: Container(
                    child: Text('$countryName',
                    
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                    fontFamily: 'Roboto',
                    fontSize: 16.0
                  ),),)),
                  Expanded(child: Container(
                    child: Text('$confirmed',
                    textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'Roboto',
                    fontSize: 14.0
                  ),),)),
                  Expanded(child: Container(
                    child: Text('$recovered', textAlign: TextAlign.right, 
                    style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'Roboto',
                    fontSize: 14.0
                  )),)),
                  Expanded(child: Container(
                    child: Text('$deaths', textAlign: TextAlign.right, 
                    style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'Roboto',
                    fontSize: 14.0
                  ))
                  )),
                ],
              ),
              Divider(),
            ],
          )
    );
  }
}

class Country {
  String countryName, date;
  int totalConfirmed, totalDeaths, totalRecovered;
  Country({this.countryName, this.totalConfirmed, this.totalDeaths, this.totalRecovered, this.date});
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}