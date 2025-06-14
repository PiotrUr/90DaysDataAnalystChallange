
# 📘 Microsoft Fabric – Study Notes (Day 11)

## 🔷 Module: Work with Delta Lake tables in Microsoft Fabric  
🔗 [Link to module](https://learn.microsoft.com/en-us/training/modules/work-with-delta-lake-tables-microsoft-fabric/)

### 🧠 Key Concepts:
🔹 **Delta Lake** is an open storage format that brings ACID transactions and schema enforcement to data lakes  
🔹 In Microsoft Fabric, Delta Lake is the default format used for tables in Lakehouse  
🔹 Delta Lake enables **versioned, reliable, and scalable** data operations

### 🔧 What I practiced:
🔹 Queried and managed **Delta tables** inside a Lakehouse using **SQL Endpoint**  
🔹 Used SQL commands like `DESCRIBE HISTORY` to track changes and table versions  
🔹 Ran **MERGE**, **INSERT**, **UPDATE**, and **DELETE** on Delta tables  
🔹 Observed how schema evolution is handled when appending new data  
🔹 Explored **time travel** capabilities through version-based queries

### ✅ Summary Takeaways:
🔹 Delta Lake makes data lakes reliable for enterprise analytics  
🔹 Time travel and version history are powerful tools for debugging and auditing  
🔹 Fabric simplifies working with Delta by tightly integrating it into Lakehouses  
🔹 The combination of SQL + version control = a strong foundation for trustworthy data pipelines
