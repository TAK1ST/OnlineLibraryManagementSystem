package dao.implement;

import dao.interfaces.IBaseDAO;
import dao.interfaces.IUserDAO;
import entity.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author asus
 */
public class UserDAO implements IUserDAO {

      private final List<User> users = new ArrayList<>();

      //      insert new line into user table =  > return 1/0 (true/false)
      public int insertNewUser(String name, String email, String password) {
            int result = 0;
//            step 1: connection Connection 
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        System.out.println("connect successfully");
                  }
//                  step 2: query and execute 
                  String sql = "insert [dbo].[users] values( ? , ? , ? , 'user' , 'active') ";
//                  init OOP, just prepare not start 
                  PreparedStatement prst = cn.prepareStatement(sql);
//                  value 1 = place at the first < ?  > 
                  prst.setString(1, name);
                  prst.setString(2, email);
                  prst.setString(3, password);
                  result = prst.executeUpdate();
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

      @Override
      public List<User> getAll() {

            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        // step 2: query and execute
                        String sql = "select [id],[name],[email], [password],[role],[status] from [dbo].[users];";
                        Statement st = cn.createStatement();
                        //ResultSet in OOP = table in Database
                        ResultSet table = st.executeQuery(sql);
                        // step 3: get data from table 
                        while (table != null && table.next()) {
                              int id = table.getInt("id");
                              String name = table.getString("name");
                              String email = table.getString("email");
                              String password = table.getString("password");
                              String role = table.getString("role");
                              String status = table.getString("status");
                              users.add(new User(id, name != null ? name : "",
                                      email != null ? email : "",
                                      password != null ? password : "",
                                      role != null ? role : "",
                                      status != null ? status : ""));
                        }
                  }
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
            return users;
      }

      @Override
      public User getId(int id) {
            User user = new User();
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        // step 2: query and execute
                        String sql = "select [id],[name],[email], [password],[role],[status] from [dbo].[users]"
                                + "where  [id] = ?";
                        PreparedStatement pst = cn.prepareStatement(sql);
                        pst.setInt(1, id);
                        //ResultSet in OOP = table in Database
                        ResultSet table = pst.executeQuery();
                        // step 3: get data from table 
                        if (table != null && table.next()) {
                              String name = table.getString("name");
                              String email = table.getString("email");
                              String password = table.getString("password");
                              String role = table.getString("role");
                              String status = table.getString("status");
                              user = new User(id, name, email, password, role, status);
                        }
                  }
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
            return user;
      }

      @Override
      public User getName(String name) {
            User user = new User();
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        // step 2: query and execute
                        String sql = "select [id],[name],[email], [password],[role],[status] from [dbo].[users]"
                                + "where  [name] = ?";
                        PreparedStatement pst = cn.prepareStatement(sql);
                        pst.setString(2, name);
                        //ResultSet in OOP = table in Database
                        ResultSet table = pst.executeQuery();
                        // step 3: get data from table 
                        if (table != null && table.next()) {
                              int id = table.getInt("id");
                              String email = table.getString("email");
                              String password = table.getString("password");
                              String role = table.getString("role");
                              String status = table.getString("status");
                              user = new User(id, name, email, password, role, status);
                        }
                  }
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
            return user;
      }

      @Override
      public User getEmail(String email) {
            User user = new User();
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        // step 2: query and execute
                        String sql = "select [id],[name],[email], [password],[role],[status] from [dbo].[users]"
                                + "where  [email] = ?";
                        PreparedStatement pst = cn.prepareStatement(sql);
                        pst.setString(1, email);
                        //ResultSet in OOP = table in Database
                        ResultSet table = pst.executeQuery();
                        // step 3: get data from table 
                        if (table != null && table.next()) {
                              int id = table.getInt("id");
                              String name = table.getString("name");
                              String password = table.getString("password");
                              String role = table.getString("role");
                              String status = table.getString("status");
                              user = new User(id, name, email, password, role, status);
                        }
                  }
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
            return user;
      }

      @Override
      public void save(User user) {
            Connection cn = null;
            PreparedStatement pst = null;

            try {
                  cn = DBConnection.getConnection();
                  if (cn == null) {
                        System.err.println("Cannot connect to database");
                        return;
                  }

                  String sql = "INSERT INTO users (name, email, password, role, status) VALUES (?, ?, ?, ?, ?)";
                  pst = cn.prepareStatement(sql);
                  pst.setString(1, user.getName());
                  pst.setString(2, user.getEmail());
                  pst.setString(3, user.getPassword());
                  pst.setString(4, user.getRole());
                  pst.setString(5, user.getStatus());

                  int rowsInserted = pst.executeUpdate();
                  if (rowsInserted > 0) {
                        System.out.println("User saved successfully!");
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            } finally {
                  try {
                        if (pst != null) {
                              pst.close();
                        }
                        if (cn != null) {
                              cn.close();
                        }
                  } catch (Exception e) {
                        e.printStackTrace();
                  }
            }
      }

      @Override
      public void delete(int userId) {
            Connection cn = null;
            PreparedStatement pst = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn == null) {
                        System.out.println("Cannot connect to database");
                        return;
                  }

                  String sql = "DELETE FROM users WHERE id = ?";
                  pst = cn.prepareStatement(sql);
                  pst.setInt(1, userId);

                  int rowsDeleted = pst.executeUpdate();
                  if (rowsDeleted > 0) {
                        System.out.println("User deleted successfully!");
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            } finally {
                  try {
                        if (pst != null) {
                              pst.close();
                        }
                        if (cn != null) {
                              cn.close();
                        }
                  } catch (Exception e) {
                        e.printStackTrace();
                  }
            }
      }
}
