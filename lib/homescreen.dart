import 'package:flutter/material.dart';
import 'package:tictacgame/game_logic.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer='X';
  bool gameOver=false;
  int turn =0;
  bool moreDifficult=false;
  String result='';
  Game game=Game();

  bool isSwitched= false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation==Orientation.portrait?Column(
          children: [
            ...startWidget(),
               expanded(),
            ...lastWidget(),
          ],
        ):Row(
          children: [
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
            ...startWidget(),
          ...lastWidget(),
      ],)),
            expanded(),
          ],
        ),
      )
    );
  }

  Widget expanded(){
    return  Expanded(child: GridView.count(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount:3,
      mainAxisSpacing : 8.0,
      crossAxisSpacing : 8.0,
      childAspectRatio : 1.0,
      children: List.generate(9,
              (index) => InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: ()=>gameOver?null:_onTap(index),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child:  Center(
                child:  Text(
                  Player.playerX.contains(index)?'X':
                  Player.playerO.contains(index)?
                  'O':'',
                  style:TextStyle(
                    color: Player.playerX.contains(index)?Colors.blue:Colors.pink,
                    fontSize: 52,
                  ),),
              ),
            ),
          )),
    ));
  }

  List<Widget> startWidget(){
    return [
      SwitchListTile.adaptive(
          title: const Text('Turn on/off  two Player',
            style:  TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,),
          value: isSwitched,
          onChanged: (bool newValue){
            setState(() {
              isSwitched=newValue;
            });
          }),
      SwitchListTile.adaptive(
          title: const Text('More difficult',
            style:  TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,),
          value: moreDifficult,
          onChanged: (bool newValue){
            setState(() {
              moreDifficult=newValue;
            });
          }),
      Text('It\'s $activePlayer Turn'.toUpperCase(),
        style:const  TextStyle(
          color: Colors.white,
          fontSize: 52,
        ),
        textAlign: TextAlign.center,),
    ];
  }
  List<Widget> lastWidget(){
    return [
      Text(result,
        style:const  TextStyle(
          color: Colors.white,
          fontSize: 42,
        ),
        textAlign: TextAlign.center,),
      ElevatedButton.icon(
        icon:const Icon(Icons.repeat),
        label: const Text('Repeat  the Game'),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Theme.of(context).splashColor)
        ),
        onPressed:(){
          setState(() {
            Player.playerO=[];
            Player.playerX=[];
            activePlayer='X';
            gameOver=false;
            turn =0;
            result='';
          });
        } ,
      ),
    ];
  }

  _onTap(int index) async{
    if(Player.playerX.isEmpty ||
    !Player.playerX.contains(index)&&
        Player.playerO.isEmpty ||
        !Player.playerO.contains(index)){
      game.playGame(index,activePlayer);
      upDateState();

      if(!isSwitched && !gameOver && turn!=9 ){
        await game.autoPlay(activePlayer,moreDifficult);
        upDateState();
      }
    }

  }
  void upDateState(){
    setState(() {
      activePlayer=(activePlayer=='X')?'O':'X';
      turn++;

      String winnerPlayer=game.checkWinner();
      if(winnerPlayer !=''){
        gameOver=true;
        result='$winnerPlayer it\'s The Winner';
      }else if(!gameOver && turn==9){
        result ='it\'s Draw';
      }
    });
  }
}
