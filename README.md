# MongoDB Driver

![Leaf](http://modules.perl6.org/logos/MongoDB.png)

## DOCUMENTATION

Plenty of documents can be found on the MongoDB site

* [MongoDB Driver Requirements](http://docs.mongodb.org/meta-driver/latest/legacy/mongodb-driver-requirements/)
* [Feature Checklist for MongoDB Drivers](http://docs.mongodb.org/meta-driver/latest/legacy/feature-checklist-for-mongodb-drivers/)
* [Database commands](http://docs.mongodb.org/manual/reference/command)
* [Collection methods](http://docs.mongodb.org/manual/reference/method/js-collection/)
* [Cursor methods](http://docs.mongodb.org/manual/reference/method/js-cursor/)
* [Administration Commands](http://docs.mongodb.org/manual/reference/command/nav-administration/)

Documentation about this driver can be found in doc/Original-README.md and the
following pod files

* lib/MongoDB.pod
* lib/MongoDB/Collection.pod
* lib/MongoDB/Connection.pod
* lib/MongoDB/Cursor.pod
* lib/MongoDB/Database.pod

When you have *Pod::To::HTML* installed and the pdf generator *wkhtmltopdf* then
you can execute the pod file with perl6 to generate a pdf from the pod document.

```
$ which wkhtmltopdf
... displays some path ...
$ panda --installed list | grep Pod::To::HTML
Pod::To::HTML   [installed]
$ cd lib/MongoDB
$ chmod u+x Connection.pod
$ Connection.pod
...
or
$ perl6 Connection.pod
...
```

## INSTALLING THE MODULES

Use panda to install the package like so. BSON will be installed as a
dependency.

```
$ panda install MongoDB
```

## VERSION PERL, MOARVM and MongoDB

```
$ perl6 -v
This is perl6 version 2015.02-188-ga99a572 built on MoarVM version 2015.02-25-g3d0404a```

The driver code is written with the highest version of MongoDB server in mind.


## FEATURE CHECKLIST FOR MONGODB DRIVERS

There are lists on the MongoDB site see references above. Items from the list
below will be worked on. There are many items shown here, it might be impossible
to implement it all. By using run_command(), much can be accomplished. A lot of the
items are using that call to get the information for you. Also quite a few items
are shown in in more than one place place. Removed all internal commands.

### Database Management

* [x] create. Happens implicitly after inserting data into a collection.
* [x] drop() Drop a database.
* [x] list_databases(). Returns database statistics.
* [x] database_names(). Returns a list of database names.
* [x] get_last_error(). Get error status from last operation
* [x] run_command(), Many helper methods are using this command.

### Role Management Commands

* [ ] createRole. Creates a role and specifies its privileges.
* [ ] dropAllRolesFromDatabase. Deletes all user-defined roles from a database.
* [ ] dropRole. Deletes the user-defined role.
* [ ] grantPrivilegesToRole. Assigns privileges to a user-defined role.
* [ ] grantRolesToRole. Specifies roles from which a user-defined role inherits privileges.
* [ ] invalidateUserCache. Flushes the in-memory cache of user information, including credentials and roles.
* [ ] revokePrivilegesFromRole. Removes the specified privileges from a user-defined role.
* [ ] revokeRolesFromRole. Removes specified inherited roles from a user-defined role.
* [ ] rolesInfo. Returns information for the specified role or roles.
* [ ] updateRole. Updates a user-defined role.

### Replication Commands

* [ ] isMaster. Displays information about this member\u2019s role in the replica set, including whether it is the master.
* [ ] replSetFreeze. Prevents the current member from seeking election as primary for a period of time.
* [ ] replSetGetStatus. Returns a document that reports on the status of the replica set.
* [ ] replSetInitiate. Initializes a new replica set.
* [ ] replSetMaintenance. Enables or disables a maintenance mode, which puts a secondary node in a RECOVERING state.
* [ ] replSetReconfig. Applies a new configuration to an existing replica set.
* [ ] replSetStepDown. Forces the current primary to step down and become a secondary, forcing an election.
* [ ] replSetSyncFrom. Explicitly override the default logic for selecting a member to replicate from.
* [ ] resync. Forces a mongod to re-synchronize from the master. For master-slave replication only.

### Sharding Commands

* [ ] addShard. Adds a shard to a sharded cluster.
* [ ] cleanupOrphaned. Removes orphaned data with shard key values outside of the ranges of the chunks owned by a shard.
* [ ] enableSharding. Enables sharding on a specific database.
* [ ] flushRouterConfig. Forces an update to the cluster metadata cached by a mongos.
* [ ] isdbgrid. Verifies that a process is a mongos.
* [ ] listShards. Returns a list of configured shards.
* [ ] mergeChunks. Provides the ability to combine chunks on a single shard.
* [ ] movePrimary. Reassigns the primary shard when removing a shard from a sharded cluster.
* [ ] removeShard. Starts the process of removing a shard from a sharded cluster.
* [ ] shardCollection. Enables the sharding functionality for a collection, allowing the collection to be sharded.
* [ ] shardingState. Reports whether the mongod is a member of a sharded cluster.
* [ ] split. Creates a new chunk.

### Collection Management

* [x] create_collection(). Create collection explicitly
* [x] drop
* [x] collection list
* [ ] collection validation

### Query and Write Operation Commands
  * find(). Find documents in a collection
    * [x] %criteria (Search criteria)
    * [x] %projection (Field selection)
    * [x] Int :$number_to_skip = 0
    * [x] Int :$number_to_return = 0
    * [x] Bool :$no_cursor_timeout = False

  * Testing find ()
    * [x] exact matching, implicit AND.
    * [x] $lt, $lte, $gt, $gte, $ne
    * [x] $in, $nin, $or, $not
    * [ ] null
    * [x] regular expressions
    * [ ] arrays, $all, $size, $slice
    * [ ] embedded docs, $elemMatch
    * [ ] $where

  * Cursors
    * [x] full cursor support (e.g. support OP_GET_MORE operation)
    * [ ] Sending the KillCursors operation when use of a cursor has completed.
          For efficiency, send these in batches.
    * [ ] Tailable cursor support
    * [ ] has_next()
    * [x] next() and fetch()
    * [ ] for_each()
    * [ ] sort()
    * [ ] limit()
    * [ ] skip()
    * [x] count(), Count docs after find using limit and skip.

  * [x] insert(). Insert documents in a collection.
  
  * [x] update(). Update documents in a collection.
    * [x] upsert
    * [x] update commands like $inc and $push

  * [x] remove(). Remove documents from a collection

  * [x] ensureIndex commands should be cached to prevent excessive communication
        with the database. Or, the driver user should be informed that
        ensureIndex is not a lightweight operation for the particular driver.

  * [x] find_one(). Search and return only one document.
    * [x] %criteria (Search criteria)
    * [x] %projection (Field selection)

  * [ ] limit
  * [ ] sort
  * [ ] eval()
  * [x] explain()
  * [ ] hint() and $hint


### Data serialization

* [x] Convert all strings to UTF-8. This is inherent to perl6. Everything is
      UTF8 and conversion to buffers is done using encode and decode.
* [x] Automatic _id generation. See BSON module.
* [ ] BSON serialization/deserialization. See BSON module and [Site](http://bsonspec.org/).
      Parts are finished but not all variable types are supported. See BSON
      documentation of what is supported.
* [ ] Support detecting max BSON size on connection (e.g., using buildInfo or
      isMaster commands) and allowing users to insert docs up to that size.
* [ ] File chunking (/applications/gridfs)

### Connection

* [ ] In/out buffer pooling, if implementing in garbage collected language
* [ ] Connection pooling
* [ ] Automatic reconnect on connection failure
* [ ] DBRef Support: - Ability to generate easily - Automatic traversal

### Authentication Commands

* [ ] authSchemaUpgrade. Supports the upgrade process for user data between version 2.4 and 2.6.
* [ ] authenticate. Starts an authenticated session using a username and password.
* [ ] logout. Terminates the current authenticated session.

### User Management Commands

* [ ] createUser. Creates a new user.
* [ ] dropAllUsersFromDatabase. Deletes all users associated with a database.
* [ ] dropUser. Removes a single user.
* [ ] grantRolesToUser. Grants a role and its privileges to a user.
* [ ] revokeRolesFromUser. Removes a role from a user.
* [ ] updateUser. Updates a user\u2019s data.
* [ ] usersInfo. Returns information about the specified users.




### User Commands

#### Aggregation Commands

* [ ] aggregate. Performs aggregation tasks such as group using the aggregation framework.
* [x] count. Counts the number of documents in a collection.
* [x] distinct. Displays the distinct values found for a specified key in a collection.
* [x] group. Groups documents in a collection by the specified key and performs simple aggregation.
* [x] mapReduce. Performs map-reduce aggregation for large data sets.

#### Geospatial Commands

* [ ] geoNear. Performs a geospatial query that returns the documents closest to a given point.
* [ ] geoSearch. Performs a geospatial query that uses MongoDB\u2019s haystack index functionality.

#### Query and Write Operation Commands

* [ ] delete. Deletes one or more documents.
* [ ] eval. Runs a JavaScript function on the database server.
* [ ] findAndModify. Returns and modifies a single document.
* [x] getLastError. Returns the success status of the last operation.
* [x] getPrevError. Returns status document containing all errors since the last resetError command.
* [x] insert. Inserts one or more documents.
* [ ] parallelCollectionScan. Lets applications use multiple parallel cursors when reading documents from a collection.
* [x] resetError. Resets the last error status.
* [ ] text. Performs a text search.
* [x] update. Updates one or more documents.

#### Query Plan Cache Commands

* [ ] planCacheClearFilters. Clears index filter(s) for a collection.
* [ ] planCacheClear. Removes cached query plan(s) for a collection.
* [ ] planCacheListFilters. Lists the index filters for a collection.
* [ ] planCacheListPlans. Displays the cached query plans for the specified query shape.
* [ ] planCacheListQueryShapes. Displays the query shapes for which cached query plans exist.
* [ ] planCacheSetFilter. Sets an index filter for a collection.

#### Administration Commands

* [ ] cloneCollectionAsCapped. Copies a non-capped collection as a new capped collection.
* [ ] cloneCollection. Copies a collection from a remote host to the current host.
* [ ] clone. Copies a database from a remote host to the current host.
* [ ] collMod. Add flags to collection to modify the behavior of MongoDB.
* [ ] compact. Defragments a collection and rebuilds the indexes.
* [ ] connectionStatus. Reports the authentication state for the current connection.
* [ ] convertToCapped. Converts a non-capped collection to a capped collection.
* [ ] copydb. Copies a database from a remote host to the current host.
* [x] createIndexes, see ensure_index(). Builds one or more indexes for a collection.
* [x] create_collection(). Creates a collection and sets collection parameters.
* [x] dropDatabase. Removes the current database.
* [x] dropIndexes. Removes indexes from a collection.
* [x] drop. Removes the specified collection from the database.
* [ ] filemd5. Returns the md5 hash for files stored using GridFS.
* [ ] fsync. Flushes pending writes to the storage layer and locks the database to allow backups.
* [ ] getParameter. Retrieves configuration options.
* [ ] logRotate. Rotates the MongoDB logs to prevent a single file from taking too much space.
* [ ] reIndex. Rebuilds all indexes on a collection.
* [ ] renameCollection. Changes the name of an existing collection.
* [ ] repairDatabase. Repairs any errors and inconsistencies with the data storage.
* [ ] setParameter. Modifies configuration options.
* [ ] shutdown. Shuts down the mongod or mongos process.
* [ ] touch. Loads documents and indexes from data storage to memory.

#### Diagnostic Commands

* [ ] buildInfo. Displays statistics about the MongoDB build.
* [ ] collStats. Reports storage utilization statics for a specified collection.
* [ ] connPoolStats. Reports statistics on the outgoing connections from this MongoDB instance to other MongoDB instances in the deployment.
* [ ] cursorInfo. Deprecated. Reports statistics on active cursors.
* [ ] dbStats. Reports storage utilization statistics for the specified database.
* [ ] features. Reports on features available in the current MongoDB instance.
* [ ] getCmdLineOpts. Returns a document with the run-time arguments to the MongoDB instance and their parsed options.
* [ ] getLog. Returns recent log messages.
* [ ] hostInfo. Returns data that reflects the underlying host system.
* [ ] indexStats. Experimental command that collects and aggregates statistics on all indexes.
* [ ] listCommands. Lists all database commands provided by the current mongod instance.
* [x] list_databases. Returns a document that lists all databases and returns basic database statistics.
* [ ] profile. Interface for the database profiler.
* [ ] serverStatus. Returns a collection metrics on instance-wide resource utilization and status.
* [ ] shardConnPoolStats. Reports statistics on a mongos\u2018s connection pool for client operations against shards.
* [ ] top. Returns raw usage statistics for each database in the mongod instance.

#### Auditing Commands

* [ ] logApplicationMessage. Posts a custom message to the audit log.

### Collection Methods

* [ ] db.collection.aggregate(). Provides access to the aggregation pipeline.
* [ ] db.collection.copyTo(). Wraps eval to copy data between collections in a single MongoDB instance.
* [x] db.collection.count(). Wraps count to return a count of the number of documents in a collection or matching a query.
* [ ] db.collection.createIndex(). Builds an index on a collection. Use db.collection.ensureIndex(). Deprecated since 1.8 according to [message](http://stackoverflow.com/questions/25968592/difference-between-createindex-and-ensureindex-in-java-using-mongodb)
* [ ] db.collection.dataSize(). Returns the size of the collection. Wraps the size field in the output of the collStats.
* [x] db.collection.distinct(). Returns an array of documents that have distinct values for the specified field.
* [x] db.collection.drop(). Removes the specified collection from the database.
* [x] db.collection.dropIndex(). Removes a specified index on a collection.
* [x] db.collection.dropIndexes(). Removes all indexes on a collection.
* [x] db.collection.ensureIndex(). Creates an index if it does not currently exist. If the index exists ensureIndex() does nothing.
* [x] db.collection.find(). Performs a query on a collection and returns a cursor object.
* [ ] db.collection.findAndModify(). Atomically modifies and returns a single document.
* [x] db.collection.findOne(). Performs a query and returns a single document.
* [ ] db.collection.getIndexStats(). Renders a human-readable view of the data collected by indexStats which reflects B-tree utilization.
* [x] db.collection.getIndexes(). Returns an array of documents that describe the existing indexes on a collection.
* [ ] db.collection.getShardDistribution(). For collections in sharded clusters, db.collection.getShardDistribution() reports data of chunk distribution.
* [x] db.collection.group(). Provides simple data aggregation function. Groups documents in a collection by a key, and processes the results. Use aggregate() for more complex data aggregation.
* [ ] db.collection.indexStats(). Renders a human-readable view of the data collected by indexStats which reflects B-tree utilization.
* [x] db.collection.insert(). Creates a new document in a collection.
* [ ] db.collection.isCapped(). Reports if a collection is a capped collection.
* [x] db.collection.mapReduce(). Performs map-reduce style data aggregation.
* [ ] db.collection.reIndex(). Rebuilds all existing indexes on a collection.
* [ ] db.collection.remove(). Deletes documents from a collection.
* [ ] db.collection.renameCollection(). Changes the name of a collection.
* [ ] db.collection.save(). Provides a wrapper around an insert() and update() to insert new documents.
* [ ] db.collection.stats(). Reports on the state of a collection. Provides a wrapper around the collStats.
* [ ] db.collection.storageSize(). Reports the total size used by the collection in bytes. Provides a wrapper around the storageSize field of the collStats output.
* [ ] db.collection.totalIndexSize(). Reports the total size used by the indexes on a collection. Provides a wrapper around the totalIndexSize field of the collStats output.
* [ ] db.collection.totalSize(). Reports the total size of a collection, including the size of all documents and all indexes on a collection.
* [x] db.collection.update(). Modifies a document in a collection.
* [ ] db.collection.validate(). Performs diagnostic operations on a collection.

### Cursor Methods

* [ ] cursor.addOption(). Adds special wire protocol flags that modify the behavior of the query.\u2019
* [ ] cursor.batchSize(). Controls the number of documents MongoDB will return to the client in a single network message.
* [x] cursor.count(). Also on collection. Returns a count of the documents in a cursor.
* [x] cursor.explain(). Done also in collection! Reports on the query execution plan, including index use, for a cursor.
* [ ] cursor.forEach(). Applies a JavaScript function for every document in a cursor.
* [ ] cursor.hasNext(). Returns true if the cursor has documents and can be iterated.
* [ ] cursor.hint(). Forces MongoDB to use a specific index for a query.
* [ ] cursor.limit(). Constrains the size of a cursor\u2019s result set.
* [ ] cursor.map(). Applies a function to each document in a cursor and collects the return values in an array.
* [ ] cursor.max(). Specifies an exclusive upper index bound for a cursor. For use with cursor.hint()
* [ ] cursor.maxTimeMS(). Specifies a cumulative time limit in milliseconds for processing operations on a cursor.
* [ ] cursor.min(). Specifies an inclusive lower index bound for a cursor. For use with cursor.hint()
* [x] cursor.next(). Returns the next document in a cursor.
* [ ] cursor.objsLeftInBatch(). Returns the number of documents left in the current cursor batch.
* [ ] cursor.readPref(). Specifies a read preference to a cursor to control how the client directs queries to a replica set.
* [ ] cursor.showDiskLoc(). Returns a cursor with modified documents that include the on-disk location of the document.
* [ ] cursor.size(). Returns a count of the documents in the cursor after applying skip() and limit() methods.
* [ ] cursor.skip(). Returns a cursor that begins returning results only after passing or skipping a number of documents.
* [ ] cursor.snapshot(). Forces the cursor to use the index on the _id field. Ensures that the cursor returns each document, with regards to the value of the _id field, only once.
* [ ] cursor.sort(). Returns results ordered according to a sort specification.
* [ ] cursor.toArray(). Returns an array that contains all documents returned by the cursor.

## BUGS, KNOWN LIMITATIONS AND TODO

Although the lists above represent one hell of a todo, below are a few notes
which I have to make to remember to add items to programmed functions. There
are also items to be implemented in BSON. You need to look there for info

* Speed, protocol correctness and clear code are priorities for now.
  * Speed can be influenced by specifying types on all variables
  * Furthermore the speedup of the language perl6 itself would have more impact
    than the programming of a one month student(me) can accomplish ;-)
* Cursor count() needs some more options such as hint.
* Change die() statements to throw exception objects to notify caller.
* Keys must be checked for illegal characters when inserting documents.
* Tests for connection to non existing server. timeout setting.
* Test to compare documents
* Test group aggregation keyf field and finalize
* Test map reduce aggregation more thoroughly

## CHANGELOG

See [semantic versioning](http://semver.org/). Please note point 4. on
that page: *Major version zero (0.y.z) is for initial development. Anything may
change at any time. The public API should not be considered stable.*

* 0.22.3 - Upgraded Rakudo * and bugfix in Protocol.pm
* 0.22.2 - Bugfixes in use of javascript
* 0.22.1 - Add use of BSON::Javascript in group() and map_reduce().
* 0.22.0 - map_reduce() in MongoDB::Collection.
* 0.21.0 - group() in MongoDB::Collection.
* 0.20.0 - list_collections() and collection_names() in MongoDB::Database
         - hint() on a cursor.
* 0.19.0 - explain() in MongoDB::Collection and MongoDB::Cursor.
* 0.18.0 - count() in MongoDB::Collection
         - distinct() in MongoDB::Collection
* 0.17.1 - Collectionnames are checked. In perl dashes are possible and are also
           accepted by the server. In the mongo shell however it is not possible
           to manipulate these names because it works in a javascript
           environment which wil see it as a substraction operator. Perhaps
           other things will go wrong too such as running javascript on the
           server. It is now tested against m/^ <[\$ _ A..Z a..z]> <[.\w _]>+ $/.
           Note the '$', It is accepted because the collection $cmd is sometimes
           used to get information from. create_collection() will also check the
           collection name but will not accept the '$'.
* 0.17.0 - create_collection() to MongoDB::Database
         - X::MongoDB::Database Exception
* 0.16.1 - Cleanup databases at the end of tests. Documented tests what is tested
* 0.16.0 - Name change X::MongoDB::LastError into X::MongoDB::Collection.
         - Added drop_indexes() drop() get_indexes() to MongoDB::Collection.
* 0.15.0 - Added drop_index() to MongoDB::Collection.
* 0.14.1 - Bugfixes find_one(), ensure_index(). Added Class X::MongoDB::LastError
           and used when ensure_index() fails.
* 0.14.0 - ensure_index() in MongoDB::Collection
* 0.13.7 - Changes depending on BSON
* 0.13.6 - MongoDB::Cursor pod document
* 0.13.0 - Added next() to MongoDB::Cursor.
* 0.12.0 - Added count() to MongoDB::Cursor.
* 0.11.1 - Added Connection.pod and Collection.pod.
* 0.11.0 - Added methods to get error status in MongoDB::Database.
* 0.10.0 - Added drop() in MongoDB::Database to drop a database.
* 0.9.0 - Added list_databases() and database_names() to MongoDB::Connection
* 0.8.0 - run_command() added to MongoDB::Database
* 0.7.4 - bugfix return values in MongoDB::Cursor
* 0.7.3 - bugfix return values in MongoDB::Protocol
* 0.7.2 - extended signatures for return values
* 0.7.1 - find extended with return_field_selector
* 0.6.1 - add tests for insert(@docs)
* 0.6.0 - switched to semantic versioning
* 0.5 - compatibility fixes for Rakudo Star 2014.12
* 0.4 - compatibility fixes for Rakudo Star 2012.02
* 0.3 - basic flags added to methods (upsert, multi_update, single_remove,...),
        kill support for cursor
* 0.2 - adapted to Rakudo NOM 2011.09+.
* 0.1 - basic Proof-of-concept working on Rakudo 2011.07.

## LICENSE

Released under [Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0).

## AUTHORS

```
Original creator of the modules is Paweł Pabian (2011-2015, v0.6.0)(bbkr on github)
Current maintainer Marcel Timmerman (2015-present) (MARTIMM on github)
```
## CONTACT

MARTIMM on github: MARTIMM/MongoDB


