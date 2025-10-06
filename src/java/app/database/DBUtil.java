/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package app.database;

/**
 *
 * @author Nhat Huy
 */
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class DBUtil {
    private static final EntityManagerFactory emf =
            Persistence.createEntityManagerFactory("C_K_PU");

    public static EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    // call at app shutdown if desired
    public static void close() {
        if (emf.isOpen()) emf.close();
    }
}