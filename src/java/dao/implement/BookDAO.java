/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.implement;


import entity.Book;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import util.DBConnection;

/**
 *
 * @author Admin
 */
public class BookDAO {
    //ham nay De lay tat ca quyen sach 
    public ArrayList<Book> getBookByTitle(String title){
        ArrayList<Book> result = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                System.out.println("connect successfully");
            }
//                  step 2: query and execute 
            String sql = "select [id],[title],[author],[isbn],[category],[published_year],[total_copies],[available_copies],[status]\n"
                    + "from [dbo].[books]\n"
                    + "where title like ?";
//                  init OOP, just prepare not start 
            PreparedStatement st = cn.prepareStatement(sql);
//                  value 1 = place at the first < ?  > 
            st.setString(1, "%"+ title +"%");
            ResultSet table = st.executeQuery();
            if(table != null){
                while(table.next()){
                    int id = table.getInt("id");
                    title = table.getString("title");
                    String author = table.getString("author");
                    String isbn = table.getString("isbn");
                    String category = table.getString("category");
                    int year = table.getInt("publishedYear");
                    int total = table.getInt("totalCopies");
                    int avaCopies = table.getInt("availableCopies");
                    String status = table.getString("status");
                    Book b= new Book(id, title, author, isbn, category, year, total, avaCopies, status);
                    result.add(b);
                }
            }
//                  step 3: get data from table 
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;        
    }
}
