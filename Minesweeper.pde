import de.bezier.guido.*;
public final static int NUM_ROWS = 5;
public final static int NUM_COLS = 5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c] = new MSButton(r,c);
        }
    }
    setMines();
}
public void setMines()
{
    while(mines.size() < NUM_COLS){
        int row = (int)(Math.random()*(NUM_ROWS));
        int col = (int)(Math.random()*(NUM_COLS));
        if (!mines.contains(buttons[row][col])) {
            mines.add(buttons[row][col]);
        }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
    else if(!isWon() == false){
        displayLosingMessage();
    }
}
public boolean isWon()
{
    for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++){
            if(!buttons[r][c].isClicked()==true && !mines.contains(buttons[r][c])){
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
    for(int i=0;i<NUM_ROWS;i++){
        for(int j=0;j<NUM_COLS;j++){
            if(!buttons[i][j].isClicked() && mines.contains(buttons[i][j])){
                buttons[i][j].flagged=false;
                buttons[i][j].clicked=true;
                buttons[0][0].setLabel("L");
                buttons[1][1].setLabel("O");
                buttons[2][2].setLabel("S");
                buttons[3][3].setLabel("E");
                buttons[4][4].setLabel("R");
            }
        }
    }
}
public void displayWinningMessage()
{
    for(int i=0;i<NUM_ROWS;i++){
        for(int j=0;j<NUM_COLS;j++){
            if(buttons[i][j].isClicked() && !mines.contains(buttons[i][j])){
            buttons[0][0].setLabel("W");
            buttons[1][1].setLabel("I");
            buttons[2][2].setLabel("N");
            buttons[3][3].setLabel("N");
            buttons[4][4].setLabel("E");
            buttons[5][5].setLabel("R");
            }
        }
    }
}
public boolean isValid(int r, int c)
{
    if(row >= 0 && col >= 0){
        if(row < NUM_ROWS && col < NUM_COLS){
            return true;
        }
  }
  return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    // for(int r = row-1; r <= row+1; r++){ 
    //     for(int c = col-1; c <= col+1; c++){ 
    //         if(isValid(r,c) == true && mines[r][c] == 5){ 
    //             numMines = numMines + 1;
    //         }
    //     }
    // }
    // if(mines[row][col] == 5){ 
    //     numMines = numMines - 1;
    // }  
    if(isValid(row-1, col-1))
    {
        if(mines.contains(buttons[row-1][col-1]))
            numMines++;
    }
    if(isValid(row-1, col))
    {
        if(mines.contains(buttons[row-1][col]))
            numMines++;
    }
    if(isValid(row-1, col+1))
    {
        if(mines.contains(buttons[row-1][col+1]))
            numMines++;
    }
    if(isValid(row, col-1))
    {
        if(mines.contains(buttons[row][col-1]))
            numMines++;
    }
    if(isValid(row, col+1))
    {
        if(mines.contains(buttons[row][col+1]))
            numMines++;
    }
    if(isValid(row+1, col-1))
    {
        if(mines.contains(buttons[row+1][col-1]))
            numMines++;
    }
    if(isValid(row+1, col))
    {
        if(mines.contains(buttons[row+1][col]))
            numMines++;
    }
    if(isValid(row+1, col+1))
    {
        if(mines.contains(buttons[row+1][col+1]))
            numMines++;
    }
}
public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = row;
        c = col; 
        x = r*width;
        y = c*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isFlagged(){
        return flagged;
    }
    public boolean isClicked(){
        return clicked;
    }
    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(keyPressed){
            flagged = !flagged;
            if(flagged == false){
                clicked = false;
            }
        }
        else if(mines.contains(this)){
            displayLosingMessage();
        }
        else if(countMines(r,c) > 0){
            myLabel = str(countMines(r,c));
        }
        else{
            // for (int rrow = r-1; rrow < r+1; rrow++) {
            //     for (int ccol = c-1; ccol < c+1; ccol++) {
            //         if(isValid(rrow,ccol) == true && buttons[rrow][ccol].isClicked() == false){
            //                 buttons[rrow][ccol].mousePressed();
            //         }
            //     }
            // }
            if(isValid(r-1, c) && !buttons[r-1][c].isClicked()){
                buttons[r-1][c].mousePressed();
            }
            if(isValid(r, c-1) && !buttons[r][c-1].isClicked()){
                buttons[r][c-1].mousePressed();
            }
            if(isValid(r, c+1) && !buttons[r][c+1].isClicked()){
                buttons[r][c+1].mousePressed();
            }
            if(isValid(r+1, c) && !buttons[r+1][c].isClicked()){
                buttons[r+1][c].mousePressed();
            }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
}
