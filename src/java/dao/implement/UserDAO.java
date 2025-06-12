package dao.implement;

import static constant.constance.RECORDS_PER_LOAD;
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

      public int insertNewUser(String name, String email, String password) {
            int result = 0;
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        System.out.println("connect successfully");
                  }
                  String sql = "insert [dbo].[users] values( ? , ? , ? , 'user' , 'active') ";
                  PreparedStatement prst = cn.prepareStatement(sql);
                  prst.setString(1, name);
                  prst.setString(2, email);
                  prst.setString(3, password);
                  result = prst.executeUpdate();
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

      public int getTotalUsers() {
            Connection cn = null;
            int count = 0;
            ResultSet rs = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        String sql = "SELECT COUNT(id) FROM [dbo].[users];";
                        Statement st = cn.createStatement();
                        ResultSet table = st.executeQuery(sql);
                        if (table.next()) {
                              count = table.getInt(1);
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
            return count;
      }

      @Override
      public List<User> getAll() {
            List<User> users = new ArrayList<>();
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        String sql = "select [id],[name],[email], [password],[role],[status] from [dbo].[users]; ";
                        Statement st = cn.createStatement();
                        ResultSet table = st.executeQuery(sql);
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

      public List<User> getUserBySearch(String email, String name, int offset) {
            List<User> userList = new ArrayList<>();
            PreparedStatement pr = null;
            ResultSet rs = null;
            Connection cn = null;
            String sql = "SELECT * FROM users WHERE 1=1 ";

            if (name != null && !name.trim().isEmpty()) {
                  sql += " AND name LIKE ?";
            }
            if (email != null && !email.trim().isEmpty()) {
                  sql += " AND email LIKE ?";
            }
            sql += " ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        pr = cn.prepareStatement(sql);
                        int paramIndex = 1;

                        if (name != null && !name.trim().isEmpty()) {
                              pr.setString(paramIndex++, "%" + name + "%");
                        }
                        if (email != null && !email.trim().isEmpty()) {
                              pr.setString(paramIndex++, "%" + email + "%");
                        }
                        pr.setInt(paramIndex++, offset);
                        pr.setInt(paramIndex, RECORDS_PER_LOAD);

                        rs = pr.executeQuery();

                        while (rs != null && rs.next()) {
                              int id = rs.getInt("id");
                              String userName = rs.getString("name");
                              String userEmail = rs.getString("email");
                              String password = rs.getString("password");
                              String role = rs.getString("role");
                              String status = rs.getString("status");
                              userList.add(new User(id,
                                      userName != null ? userName : "",
                                      userEmail != null ? userEmail : "",
                                      password != null ? password : "",
                                      role != null ? role : "",
                                      status != null ? status : ""));
                        }
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            } finally {
                  try {
                        if (rs != null) {
                              rs.close();
                        }
                        if (pr != null) {
                              pr.close();
                        }
                        if (cn != null) {
                              cn.close();
                        }
                  } catch (Exception e) {
                        e.printStackTrace();
                  }
            }
            return userList;
      }

      public List<User> getUserLazyPageLoading(int offset) {
            List<User> userList = new ArrayList<>();
            Connection cn = null;
            PreparedStatement pr = null;
            ResultSet rs = null;

            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        String sql = "SELECT * FROM users ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
                        pr = cn.prepareStatement(sql);
                        pr.setInt(1, offset);
                        pr.setInt(2, RECORDS_PER_LOAD);
                        rs = pr.executeQuery();

                        while (rs != null && rs.next()) {
                              int id = rs.getInt("id");
                              String name = rs.getString("name");
                              String email = rs.getString("email");
                              String password = rs.getString("password");
                              String role = rs.getString("role");
                              String status = rs.getString("status");
                              userList.add(new User(id,
                                      name != null ? name : "",
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
                        if (rs != null) {
                              rs.close();
                        }
                        if (pr != null) {
                              pr.close();
                        }
                        if (cn != null) {
                              cn.close();
                        }
                  } catch (Exception e) {
                        e.printStackTrace();
                  }
            }
            return userList;
      }

      public User getUser(String email, String password) {
            User result = null;
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        String sql = "select id,name,email,password,role,status\n"
                                + "from dbo.users\n"
                                + "where email=? and password=?  COLLATE Latin1_General_CS_AS";
                        PreparedStatement st = cn.prepareStatement(sql);
                        st.setString(1, email);
                        st.setString(2, password);

                        ResultSet table = st.executeQuery();
                        if (table != null && table.next()) {
                              int id = table.getInt("id");
                              String name = table.getString("name");
                              String role = table.getString("role");
                              String status = table.getString("status");
                              result = new User(id, name, email, password, role, status);
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
            return result;
      }

      @Override
      public User getId(int id) {
            User user = new User();
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        String sql = "select [id],[name],[email], [password],[role],[status] from [dbo].[users] where [id] = ?";
                        PreparedStatement pst = cn.prepareStatement(sql);
                        pst.setInt(1, id);
                        ResultSet table = pst.executeQuery();
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
                        String sql = "select [id],[name],[email], [password],[role],[status] from [dbo].[users] where [name] = ?";
                        PreparedStatement pst = cn.prepareStatement(sql);
                        pst.setString(1, name);
                        ResultSet table = pst.executeQuery();
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
            User result = null;
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        String sql = "select id,name,email,password,role,status from dbo.users where email=?";
                        PreparedStatement st = cn.prepareStatement(sql);
                        st.setString(1, email);
                        ResultSet table = st.executeQuery();
                        if (table != null && table.next()) {
                              int id = table.getInt("id");
                              String name = table.getString("name");
                              String password = table.getString("password");
                              String role = table.getString("role");
                              String status = table.getString("status");
                              result = new User(id, name, email, password, role, status);
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
            return result;
      }

      @Override
      public void save(User user) {
            Connection cn = null;
            PreparedStatement pst = null;

            try {
                  cn = DBConnection.getConnection();
                  if (cn == null) {
                        System.out.println("Cannot connect to database");
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

      public int updateUser(int userId, String username, String password, String status) {
            int result = 0;
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        StringBuilder sql = new StringBuilder("UPDATE [dbo].[users] SET ");
                        List<Object> parameters = new ArrayList<>();

                        if (username != null) {
                              sql.append("[name] = ?, ");
                              parameters.add(username);
                        }
                        if (password != null) {
                              sql.append("[password] = ?, ");
                              parameters.add(password);
                        }
                        if (status != null) {
                              sql.append("[status] = ?, ");
                              parameters.add(status);
                        }

                        if (parameters.isEmpty()) {
                              return 0; 
                        }

                        // remove the ',' at last
                        sql.setLength(sql.length() - 2);

                        sql.append(" WHERE id = ?");
                        parameters.add(userId);

                        PreparedStatement st = cn.prepareStatement(sql.toString()); 
                        
                        // get object in list
                        for (int i = 0; i < parameters.size(); i++) {
                              st.setObject(i + 1, parameters.get(i));
                        }

                        result = st.executeUpdate();
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
            return result;
      }
}
