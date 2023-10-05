/**
 StreamBuilder<List<UserModel>>(
//Affichage etudiants
stream: sessionService.getSession('${widget.session.code}'),
builder: (context, snapshot) {
if (snapshot.hasData) {
List<UserModel> session = snapshot.data!;
if (session.isEmpty) {
return Center(
child: Text("Error."),
);
}
return ListView.builder(
itemCount: session.length,
itemBuilder: (context, index) {
return Card(
elevation: 4, // Ajout d'une ombre pour la carte
color: Color.fromARGB(
255, 118, 189, 224), // Couleur de la carte

child: ListTile(
title: Text(session[index].type),
);
} else if (snapshot.hasError) {
return Text('Error: ${snapshot.error}');
} else {
return Center(child: CircularProgressIndicator());
}
},
),**/